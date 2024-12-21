import 'package:flutter/material.dart';

class QRResultat extends StatelessWidget {

  final String content;

  const QRResultat({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F8F0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                          size: 16.0,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        "Réservation confirmée :",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Voici les informations concernant ce client :',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Voici la réservation de XX personnes :',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 16.0),
                  const Row(
                    children: [
                      Text(
                        'Table : ',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        'NUMERO',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Critères choisis en cas de table prise :',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 8.0),
                  bulletPoint('Face à la mer'),
                  bulletPoint('Extérieur'),
                  const SizedBox(height: 16.0),
                  const Row(
                    children: [
                      Text(
                        'Date : ',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        'JJ/MM/AAAA',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  const Row(
                    children: [
                      Text(
                        'Heure : ',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        'HH:MM',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
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

  Widget bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
      child: Row(
        children: [
          Container(
            width: 4.0,
            height: 4.0,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8.0),
          Text(text, style: const TextStyle(fontSize: 14.0)),
        ],
      ),
    );
  }
}