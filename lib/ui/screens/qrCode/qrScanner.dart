import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:http/http.dart' as http;
import './qrResultat.dart';
import 'dart:convert';
import '../../../utils/config.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedText;
  bool isFlashOn = false; // Indique l'état du flash, pour l'icone
  bool isError = false; // Indique si le QR code est invalide
  String errorMessage = ''; // Message d'erreur à afficher

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
      ),
      body: Stack(
        children: [
          // Vue caméra
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          // Carré de guidage au centre
          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
              ),
            ),
          ),
          // Texte détecté
          if (scannedText != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'QR Code détecté : $scannedText',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          // Affichage de l'erreur si le QR code est invalide
          if (isError)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.redAccent,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          // Icône de flash en bas à droite
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                backgroundColor: Colors.black.withOpacity(0.7),
                onPressed: _toggleFlash,
                child: Icon(
                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.yellow,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();

      setState(() {
        scannedText = scanData.code;
      });

      // Vérifier si le QR code correspond à une réservation
      _checkReservation(scannedText ?? "");
    });
  }

  Future<void> _checkReservation(String qrCode) async {
    var headers = {
      'Accept': 'application/json',
    };
    var request = http.Request('GET', Uri.parse('${AppConfig.baseUrl}/reservation/qrCode/?QrCode=$qrCode'));
    request.body = '''''';
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Convertir la réponse en chaîne et puis en liste dynamique
        String responseData = await response.stream.bytesToString();

        // Convertir le corps JSON en une liste dynamique
        final List<dynamic> data = jsonDecode(responseData);

        if (data.isNotEmpty) {
          // Si les données ne sont pas vides, traiter les informations de réservation
          setState(() {
            isError = false;
          });

          // Rediriger vers la page de résultats avec les détails de la réservation
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRResultat(content: responseData),
            ),
          ).then((_) {
            controller?.resumeCamera(); // Reprend la caméra après navigation
          });
        } else {
          // Si le QR code n'est pas valide (réponse vide)
          setState(() {
            isError = true;
            errorMessage = 'QR Code invalide ou non trouvé dans la base de données.';
          });
        }
      } else {
        // Si l'API renvoie une erreur
        setState(() {
          isError = true;
          errorMessage = 'Erreur serveur: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      // Si une erreur de connexion se produit
      setState(() {
        isError = true;
        errorMessage = 'Erreur de connexion: $e';
      });
    }
  }

  Future<void> _toggleFlash() async {
    if (controller != null) {
      await controller?.toggleFlash();
      final flashStatus = await controller?.getFlashStatus() ?? false;
      setState(() {
        isFlashOn = flashStatus; // Met à jour l'état du flash
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
