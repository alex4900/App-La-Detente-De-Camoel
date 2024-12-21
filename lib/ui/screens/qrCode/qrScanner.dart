import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedText; // Stocke le texte du QR code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          // Ajout d'un carré centré
          Center(
            child: Container(
              width: 150, // Largeur du carré
              height: 150, // Hauteur du carré
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
              ),
            ),
          ),
          // Affichage du texte scanné
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller?.toggleFlash();
        },
        child: const Icon(Icons.flash_on),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Met à jour l'état avec le texte du QR code
      setState(() {
        scannedText = scanData.code;
      });

      // Optionnel : arrêter le scanner après une détection
      controller.pauseCamera();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
