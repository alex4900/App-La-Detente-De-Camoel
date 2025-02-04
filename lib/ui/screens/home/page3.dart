import 'package:flutter/material.dart';
import 'page2.dart';
import '../HomePageScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Page3 extends StatefulWidget {
  static List<Map<String, dynamic>> confirmedOrders = [];

  static void addOrder(List<dynamic> items, double total,
      {required String tableNumber, required String commentaireClient}) {
    // Insert new order at the beginning of the list
    confirmedOrders.insert(0, {
      'id': DateTime.now().toString(),
      'items': items,
      'total': total,
      'status': 'En attente',
      'timestamp': DateTime.now(),
      'tableNumber': tableNumber,
      'commentaireClient': commentaireClient,
    });
  }

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'en attente':
        return '#FFA500'; // Orange
      case 'modifié':
        return '#4169E1'; // Bleu royal
      case 'prêt':
        return '#2E7D32'; // Vert foncé
      case 'annulé':
        return '#757575'; // Gris
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
    // Avant de naviguer vers la page de modification
    setState(() {
      order['status'] = 'Modifié'; // Change le statut à "Modifié"
    });

    // Sauvegarder les items de la commande dans Page2
    Page2.savedItems = Map.fromEntries(
      (order['items'] as List).map((item) => MapEntry(
        item['IDPLAT'].toString(),
        {...item},
      )),
    );
    Page2.savedTotal = order['total'];
    Page2.tableNumber = order['tableNumber']; // Add this static variable in Page2
  
  // Keep track of order being modified
    Page2.orderBeingModified = order; // Add this static variable in Page2
  
    

     // Navigate to Page2
  Navigator.pushReplacement(
    context, 
    MaterialPageRoute(
      builder: (context) => HomePageScreen(
        initialIndex: 2,
      )
    ),
  );
}

  Future<void> confirmOrder(Map<String, dynamic> order) async {
    try {
      //valide table
      if (order['tableNumber'].isEmpty || !RegExp(r'^[0-9]+$').hasMatch(order['tableNumber'])) {
      throw Exception('Numéro de table invalide');
    }
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Non authentifié');
      }

      // Nouvelle structure pour l'API
      final orderData = {
  'commentaireClient': order['commentaireClient'],
  'tableNumber': order['tableNumber'],
  'plats': (order['items'] as List).map((item) => {
    'idPlat': item['IDPLAT'],
    'qte': item['quantity'],
    'commentaire': item['comment'] ?? '',
  }).toList(),
};

      final response = await http.post(
        Uri.parse(AppConfig.ordersEndpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(orderData),
      );




      print("\n\n\n"+jsonEncode(orderData)+"\n\n"+order['items'].toString()+"\n");




      print(response.body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        setState(() {
          order['status'] = 'Prêt'; // Change le statut à "Prêt"
          order['idCommande'] = responseData['IDCOMMANDE']; // Stocke l'ID de commande retourné
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Commande confirmée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erreur lors de la confirmation');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quantité: ${item['quantity']} - Prix: ${(item['PRIXPLATHT'] * item['quantity']).toStringAsFixed(2)}€',
                                ),
                                if (item['comment']?.isNotEmpty ?? false)
                                  Text(
                                    'Commentaire: ${item['comment']}',
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
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
                            if (order['status'] == 'En attente' || order['status'] == 'Modifié')
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => confirmOrder(order),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[600], // Vert plus foncé pour meilleure lisibilité
                                    ),
                                    child: const Text('Confirmer'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => modifyOrder(order),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[600], // Bleu plus foncé pour meilleure lisibilité
                                    ),
                                    child: const Text('Modifier'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => showCancelDialog(order),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[400], // Gris au lieu de rouge
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
                    ],
                  ),
                );
              },
            ),
    );
  }
}
