import 'package:flutter/material.dart';
import 'page2.dart';
import '../HomePageScreen.dart';

class Page3 extends StatefulWidget {
  static List<Map<String, dynamic>> confirmedOrders = [];

  static void addOrder(List<dynamic> items, double total,
      {required String tableNumber}) {
    // Insert new order at the beginning of the list
    confirmedOrders.insert(0, {
      'id': DateTime.now().toString(),
      'items': items,
      'total': total,
      'status': 'En attente',
      'timestamp': DateTime.now(),
      'tableNumber': tableNumber,
    });
  }

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'en attente':
        return '#FFA500';
      case 'en préparation':
        return '#4169E1';
      case 'prêt':
        return '#32CD32';
      case 'annulé':
        return '#FF0000';
      default:
        return '#808080';
    }
  }

  void showCancelDialog(Map<String, dynamic> order) {
    String cancelReason = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Raison de l\'annulation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Sélectionnez une raison',
                ),
                items: const [
                  DropdownMenuItem(value: 'client', child: Text('Annulation client')),
                  DropdownMenuItem(value: 'erreur', child: Text('Erreur de saisie')),
                  DropdownMenuItem(value: 'rupture', child: Text('Rupture de stock')),
                  DropdownMenuItem(value: 'technique', child: Text('Problème technique')),
                  DropdownMenuItem(value: 'autre', child: Text('Autre raison')),
                ],
                onChanged: (value) {
                  cancelReason = value ?? '';
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Confirmer'),
              onPressed: () {
                setState(() {
                  order['status'] = 'Annulé';
                  order['cancelReason'] = cancelReason;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void modifyOrder(Map<String, dynamic> order) {
    // Sauvegarder les items de la commande dans Page2
    Page2.savedItems = Map.fromEntries(
      (order['items'] as List).map((item) => MapEntry(
        item['IDPLAT'].toString(),
        {...item},
      )),
    );
    Page2.savedTotal = order['total'];
    
    // Supprimer la commande actuelle
    setState(() {
      Page3.confirmedOrders.remove(order);
    });

    // Naviguer vers Page2
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePageScreen(initialIndex: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statut des commandes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: Page3.confirmedOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Aucune commande en cours',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: Page3.confirmedOrders.length,
              itemBuilder: (context, index) {
                // Get the order number (newest order = highest number)
                final orderNumber = Page3.confirmedOrders.length - index;
                // Get the order (newest orders first)
                final order = Page3.confirmedOrders[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          'Commande #$orderNumber',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(
                              int.parse(
                                    getStatusColor(order['status'])
                                        .substring(1, 7),
                                    radix: 16,
                                  ) +
                                  0xFF000000,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            order['status'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Table ${order['tableNumber']}',
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    subtitle: Text(
                      'Commandé le ${order['timestamp'].toString().substring(0, 16)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    children: [
                      const Divider(),
                      ...List.generate(
                        (order['items'] as List).length,
                        (itemIndex) {
                          final item = order['items'][itemIndex];
                          return ListTile(
                            title: Text(item['LIBELLEPLAT']),
                            subtitle: Text(
                              'Quantité: ${item['quantity']} - Prix: ${(item['PRIXPLATHT'] * item['quantity']).toStringAsFixed(2)}€',
                            ),
                            trailing: item['VEGGIE']
                                ? const Icon(Icons.eco, color: Colors.green)
                                : null,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Total row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${order['total'].toStringAsFixed(2)}€',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Action buttons row
                            if (order['status'] == 'En attente')
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => setState(() {
                                      order['status'] = 'Prêt';
                                    }),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text('Confirmer'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => modifyOrder(order),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: const Text('Modifier'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => showCancelDialog(order),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Annuler'),
                                  ),
                                ],
                              ),
                            if (order['cancelReason'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Raison d\'annulation: ${order['cancelReason']}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Ajout des boutons d'action
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Logique pour confirmer
                                setState(() {
                                  order['status'] = 'prêt';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF32CD32), // Vert
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Confirmer'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Logique pour modifier
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF4169E1), // Bleu
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Modifier'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Logique pour annuler
                                setState(() {
                                  Page3.confirmedOrders.removeAt(index);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey, // Gris
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Annuler'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
