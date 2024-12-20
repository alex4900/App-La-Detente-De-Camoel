import 'package:flutter/material.dart';

import 'tabs/page1.dart';
import 'tabs/page2.dart';
import 'tabs/page3.dart';
import 'tabs/page4.dart';

// Screen permettant d'afficher deux tabs : une liste d'éléments et une vue À propos
class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  createState() => _HomePageScreenState();
}

// State de la page. Il contient les tabs et gère l'affichage
class _HomePageScreenState extends State {
  // Index de l'onglet sélectionné au démarrage de la vue nous initialisons à 0
  // pour afficher le premier onglet
  int _currentIndex = 0;

  // Liste des tabs présent dans la page
  final List<Widget> _children = <Widget>[
    const Page1(),
    const Page2(),
    const Page3(),
    const Page4(),
  ];

  // Liste des titres affiché en haut de la page
  final List<String> _titles = <String>[
    'Scan QR',
    'Nouvelle commande',
    'Status commandes',
    'Chat',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(_titles[_currentIndex]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('À propos'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      // Le contenu de la page est affiché est fonction de l'index de la tab sélectionnée
      body: _children[_currentIndex],

      // BottomNavigationBar permet d'afficher les tabs en bas de la page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Liste',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'À Propos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mon Compte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mon Compte',
          ),
        ],
      ),
    );
  }

  // Méthode appelée lorsqu'on clique sur une tab
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}