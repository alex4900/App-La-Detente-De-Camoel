import 'package:flutter/material.dart';
import './qrResultat.dart';

class ReservationPasseePage extends StatelessWidget {
  final Map<String, dynamic> content;

  const ReservationPasseePage({Key? key, required this.content}) : super(key: key);

  String getTimeDifference(DateTime startDateTime, DateTime endDateTime) {
    // j'ai merdé j'ai inversé les deux mais c.dart'est pas grave ça fonctionne

    Duration difference = DateTime.now().difference(startDateTime);


    if (difference.inDays > 0) {
      return '${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    }
  }


  @override
  Widget build(BuildContext context) {

    String reservationDateString = "${content['date']} ${content['heure']}";
    String dateFinString = "${content['DateFin']} ${content['HeureFin']}";

    List<String> reservationParts = reservationDateString.split(' ');
    List<String> dateParts = reservationParts[0].split('/');
    List<String> timeParts = reservationParts[1].split(':');

    int resDay = int.parse(dateParts[0]);
    int resMonth = int.parse(dateParts[1]);
    int resYear = int.parse(dateParts[2]);
    int resHour = int.parse(timeParts[0]);
    int resMinute = int.parse(timeParts[1]);

    DateTime reservationDateTime = DateTime(resYear, resMonth, resDay, resHour, resMinute);

    List<String> dateFinParts = dateFinString.split(' ');
    List<String> dateFinDateParts = dateFinParts[0].split('/');
    List<String> dateFinTimeParts = dateFinParts[1].split(':');

    int finDay = int.parse(dateFinDateParts[0]);
    int finMonth = int.parse(dateFinDateParts[1]);
    int finYear = int.parse(dateFinDateParts[2]);
    int finHour = int.parse(dateFinTimeParts[0]);
    int finMinute = int.parse(dateFinTimeParts[1]);

    DateTime dateFinDateTime = DateTime(finYear, finMonth, finDay, finHour, finMinute);

    String timeAgo = getTimeDifference(dateFinDateTime, reservationDateTime);


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
                color: const Color(0xFFFFE0E0), // couleurs à gerer dans le theme.dart plus tard
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
            // Messages d'erreur
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Le QR code a été scanné il y a $timeAgo.',
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Cette réservation a été validée le ${content['DateFin']} à ${content['HeureFin']}.',
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ],
            ),

            const SizedBox(height: 30.0),

            // les deux boutons

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
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

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRResultat(content: content), // on va, si c'est ok pour le
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
