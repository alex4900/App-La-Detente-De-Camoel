import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Désactive le bouton retour automatique
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
        title: const Text('Nouvelle commande'),
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
                'Menu du Restaurant',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Retour'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_drink),
              title: const Text('Boissons'),
              onTap: () {
                Navigator.pop(context);
                // Ajouter votre logique ici
              },
            ),
            ListTile(
              leading: const Icon(Icons.wine_bar),
              title: const Text('Alcools'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text('Entrées'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dinner_dining),
              title: const Text('Plats'),
              onTap: () {
                Navigator.pop(context);
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.cake),
              title: const Text('Desserts'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Nouvelle Commande'),
      ),
    );
  }
}