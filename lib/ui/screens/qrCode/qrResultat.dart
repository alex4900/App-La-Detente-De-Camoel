import 'package:flutter/material.dart';
import 'changerTable.dart';
import 'package:android_detente_camoel/utils/QRFonctions.dart';

class QRResultat extends StatelessWidget {
  final Map<String, dynamic> content;

  const QRResultat({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservation'),
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
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F8F0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFF00B67A),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      const Text(
                        'Réservation confirmée',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    'Voici les informations concernant ce client :',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30.0),

            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 330),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14.0, color: Colors.black),
                      children: [
                        const TextSpan(text: 'Voici la réservation de '),
                        TextSpan(
                          text: '${content['nombre_personnes']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' :'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    children: [
                      const Text(
                        'Table numéro : ',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        content['table'],
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 24.0),
                  Row(
                    children: [
                      const Text(
                        'Date : ',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        content['date'],
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      const Text(
                        'Heure : ',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        content['heure'],
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Critères choisis en cas de table prise :',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    content['commentaire'],
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,

                    ),
                  ),

                ],
              ),
            ),
            const Spacer(flex: 2),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async { // 10 ans pour comprendre le async
                      final contenuTables = await recupererInfoTables();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChangerTable(content: contenuTables, commentaires: content['commentaire']),
                        ),
                      );
                    },

                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: const Text('Changer de table'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Prendre sa commande',
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

  Future<List<dynamic>> recupererInfoTables() async {

    // Oral : On ajoute un flashlight en cas de manque de lisibilité sur une feuille
    List<dynamic> infoTables = await recupererTables();
    return infoTables;

  }
}


