import 'package:flutter/material.dart';
import './qrResultat.dart';

class ReservationPasseePage extends StatelessWidget {
  final Map<String, dynamic> content;

  const ReservationPasseePage({Key? key, required this.content}) : super(key: key);

  String getTimeDifference(DateTime reservationDateTime) {
    // Récupérer la date et l'heure actuelles
    DateTime currentDateTime = DateTime.now();

    // Calculer la différence entre les dates
    Duration difference = currentDateTime.difference(reservationDateTime);

    // Formater la différence en jours, heures, etc.
    if (difference.inDays > 0) {
      return '${difference.inDays} jours';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} heures';
    } else {
      return '${difference.inMinutes} minutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Convertir la date et l'heure de la réservation en DateTime
    DateTime reservationDateTime = DateTime.parse("${content['date']} ${content['heure']}");

    // Obtenir la différence de temps depuis la réservation
    String timeAgo = getTimeDifference(reservationDateTime);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Erreur
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0E0), // Couleur d'arrière-plan pour l'erreur
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3D3D),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  const Text(
                    'Erreur',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            // Message d'erreur
            Text(
              'Ce QR code a déjà été scanné il y a $timeAgo.',
              style: const TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            const SizedBox(height: 30.0),
            // Boutons Annuler et Continuer
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Logique pour annuler
                      Navigator.pop(context); // Retourner à l'écran précédent
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Logique pour continuer
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRResultat(content: content), // Aller à la page de détails de réservation
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Continuer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
