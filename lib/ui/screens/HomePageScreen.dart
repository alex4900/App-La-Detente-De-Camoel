import 'package:android_detente_camoel/ui/screens/connexion/connexion.dart';
import 'package:flutter/material.dart';

import 'connexion/connexion.dart';
import 'home/page1.dart';
import 'home/page2.dart';
import 'home/page3.dart';
import 'home/page4.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _currentIndex = 1;

  // Page login ajoutée au début de la liste (index 0)
  final List<Widget> _children = const <Widget>[
    Connexion(),
    Page1(),
    Page2(),
    Page3(),
    Page4(),
  ];

  final List<String> _titles = <String>[
    'Connexion',  // Titre pour la page de login
    'Scan QR',
    'Nouvelle commande',
    'Status commandes',
    'Chat',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _children[_currentIndex],
      // Affiche la navbar seulement si on n'est pas sur la page login et que l'index <= 2
      bottomNavigationBar: _currentIndex != 0 && _currentIndex <= 4
          ? BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        // Décale l'index de -1 car la page login n'est pas dans la navbar
        currentIndex: _currentIndex - 1,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: 'Commander',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      )
          : null,
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index + 1;
    });
  }
}