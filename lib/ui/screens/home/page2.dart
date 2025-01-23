import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../utils/config.dart';
import 'page3.dart';

class Page2 extends StatefulWidget {
  static Map<String, Map<String, dynamic  >> savedItems = {};
  static double savedTotal = 0.0;
  static String savedSection = 'Boissons';
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  List<dynamic> allItems = [];
  Map<String, Map<String, dynamic>> selectedItems = {};
  bool isLoading = false;
  String currentSection = 'Boissons'; // Set default section
  double totalAmount = 0.0;

  final Map<String, int> categoryIds = {
    'Entrées': 1,
    'Plats': 2,
    'Desserts': 3,
    'Boissons': 4,
    'Fromages': 6,
    'Alcools': 7,
  };

  @override
  void initState() {
    super.initState();
    // Restore saved state
    selectedItems = Map.from(Page2.savedItems);
    totalAmount = Page2.savedTotal;
    currentSection = Page2.savedSection;
    fetchAllItems();
  }

  Future<void> fetchAllItems() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/plats'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          allItems = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  void updateTotal() {
    setState(() {
      totalAmount = selectedItems.values.fold(
        0,
        (sum, item) => sum + (item['PRIXPLATHT'] * item['quantity'] as num),
      );
    });
  }

  void showCartPreview() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return selectedItems.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Aucun article sélectionné'),
                  ),
                )
              : Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Votre commande',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedItems.length,
                      itemBuilder: (context, index) {
                        final item = selectedItems.values.elementAt(index);
                        return ListTile(
                          title: Text(item['LIBELLEPLAT']),
                          subtitle: Text('${item['PRIXPLATHT']}€ x ${item['quantity']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () {
                                  setState(() {
                                    updateItemQuantity(item['IDPLAT'], -1);
                                  });
                                  setModalState(() {});
                                },
                              ),
                              Text('${item['quantity']}'),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                onPressed: () {
                                  setState(() {
                                    updateItemQuantity(item['IDPLAT'], 1);
                                  });
                                  setModalState(() {});
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total: ${totalAmount.toStringAsFixed(2)}€',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      submitOrder();
                    },
                    child: const Text('Valider la commande'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void updateItemQuantity(dynamic itemId, int change) {
    setState(() {
      final id = itemId.toString();
      if (selectedItems.containsKey(id)) {
        selectedItems[id]!['quantity'] += change;
        if (selectedItems[id]!['quantity'] <= 0) {
          selectedItems.remove(id);
        }
      } else if (change > 0) {
        final item = allItems.firstWhere((item) => item['IDPLAT'] == itemId);
        selectedItems[id] = {...item, 'quantity': 1};
      }
      updateTotal();
      // Save state after updates
      Page2.savedItems = Map.from(selectedItems);
      Page2.savedTotal = totalAmount;
    });
  }

  void submitOrder() {
  if (selectedItems.isNotEmpty) {
    final orderItems = selectedItems.values.map((item) => {
      ...item,
      'quantity': item['quantity'],
      'PRIXPLATHT': item['PRIXPLATHT'],
      'LIBELLEPLAT': item['LIBELLEPLAT'],
      'VEGGIE': item['VEGGIE'],
    }).toList();

    Page3.addOrder(orderItems, totalAmount);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Commande envoyée avec succès!')),
    );
    
    setState(() {
      selectedItems.clear();
      totalAmount = 0;
      Page2.savedItems.clear();
      Page2.savedTotal = 0;
    });

    // Navigate to status page after clearing state
    Navigator.pushNamed(context, '/status').then((_) {
      // Refresh state when returning from status page
      setState(() {});
    });
  }
}

  List<dynamic> getItemsByCategory() {
    if (currentSection.isEmpty) return [];
    final categoryId = categoryIds[currentSection];
    return allItems.where((item) => item['IDTYPEPLAT'] == categoryId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(currentSection.isEmpty ? 'Nouvelle commande' : currentSection),
        actions: [
          if (selectedItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: showCartPreview,
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu du Restaurant',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.local_drink),
              title: const Text('Boissons'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  currentSection = 'Boissons';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.wine_bar),
              title: const Text('Alcools'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  currentSection = 'Alcools';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text('Entrées'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  currentSection = 'Entrées';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.dinner_dining),
              title: const Text('Plats'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  currentSection = 'Plats';
                });
              },
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: SvgPicture.asset(
                  'images/cheese-3-svgrepo-com.svg',
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              title: const Text('Fromages'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  currentSection = 'Fromages';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.cake),
              title: const Text('Desserts'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  currentSection = 'Desserts';
                });
              },
            ),
          ],
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredItems = getItemsByCategory();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final id = item['IDPLAT'].toString();
        final isSelected = selectedItems.containsKey(id);
        final quantity = selectedItems[id]?['quantity'] ?? 0;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(item['LIBELLEPLAT']),
            subtitle: Text('${item['PRIXPLATHT']}€'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item['VEGGIE'])
                  const Icon(Icons.eco, color: Colors.green),
                const SizedBox(width: 8),
                if (isSelected) ...[
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => updateItemQuantity(item['IDPLAT'], -1),
                  ),
                  Text('$quantity'),
                ],
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () => updateItemQuantity(item['IDPLAT'], 1),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}