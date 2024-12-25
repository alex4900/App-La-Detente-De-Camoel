import 'package:flutter/material.dart';
import 'package:android_detente_camoel/utils/QRFonctions.dart';

class ChangerTable extends StatefulWidget {

  final List<dynamic> content;
  final String commentaires;
  final String idTable;
  final String idReservation;
  const ChangerTable({super.key,
    required this.content,
    required this.commentaires,
    required this.idTable,
    required this.idReservation,
  }); //Merci StackOverFlow, merci ça ne se voit pas ici.

  @override
  State<ChangerTable> createState() => _ChangerTableState();
}

class _ChangerTableState extends State<ChangerTable> {
  int? idTableSelectionnee;
   // on récupere les infos des tables, #jenaimarre

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

          const SizedBox(height: 12.0),

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
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Text(
                      widget.commentaires, // encore merci stackOverflow
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Critères choisis en cas de table prise : ',
                  style: TextStyle(fontSize: 14.0),
                ),



              ],
            ),
          ),
            const SizedBox(height: 24.0),

            Expanded(
              child: ListView(
                children: widget.content.map<Widget>((table) {
                  final idTable = table['IDTABLE'];
                  final isDisponible = table['ESTDISPO'];

                  return RadioListTile<int>(
                    title: Text(
                      isDisponible
                          ? 'Table $idTable'
                          : 'Table $idTable (Pas disponible)',
                      style: TextStyle(
                        color: isDisponible ? Colors.black : Colors.grey,
                      ),
                    ),
                    value: idTable,
                    groupValue: idTableSelectionnee,
                    selected: idTable.toString() == widget.idTable,
                    onChanged: (value) {
                      setState(() {
                        idTableSelectionnee = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    if (idTableSelectionnee == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez sélectionner une table.'),
                        ),
                      );
                      return;
                    }


                    ScaffoldMessenger.of(context).showSnackBar(
                      // En attendant la réponse du saint serveur
                      const SnackBar(
                        content: Text('Changement de table en cours...'),
                      ),
                    );

                    try {
                      final result = await changerTables(widget.idReservation, idTableSelectionnee);

                      if (result[1] != -1) { // Si il n'y a pas d'erreur
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Table changée avec succès ! Nouvelle table : ${result[1]}'),
                          ),
                        );

                        // Puis, on revient en arrière
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.of(context).pop({
                            'newTable': result[1]
                          });
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erreur : ${result[0]}'),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Une erreur est survenue : $e'),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    side: const BorderSide(color: Colors.blue),
                  ),
                  child: const Text('Changer de table'),
                ),
              ),

              /*
                * TODO : mettre à jour la table sur la reservation
                * Ca ne met pas encore à jour l'application quand on revient en arrière.
              */

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

  @override
  void initState() {
    super.initState();
    idTableSelectionnee = int.tryParse(widget.idTable);
  }

}
