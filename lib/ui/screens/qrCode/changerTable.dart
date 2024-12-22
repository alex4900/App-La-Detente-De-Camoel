import 'package:flutter/material.dart';

class ChangerTable extends StatefulWidget {
  const ChangerTable({super.key});

  @override
  State<ChangerTable> createState() => _ChangerTableState();
}

class _ChangerTableState extends State<ChangerTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changer de table'),
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
                      const TextSpan(text: 'Voici les critères choisis en cas de table prise :'),
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
                      "content['table']",
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Critères choisis en cas de table prise :',
                  style: TextStyle(fontSize: 14.0),
                ),

              ],
            ),
          ),
          const Spacer(flex: 2),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangerTable(),
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
}
