import 'package:flutter/material.dart';

class Connexion extends StatefulWidget {
  const Connexion({Key? key}) : super(key: key);

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final TextEditingController emailInput = TextEditingController();
  final TextEditingController passwordInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 50,
                ),
                child: Column(
                  children: [
                    // Image de profil
                    SizedBox(
                      height: 230,
                      child: Image.asset(
                        'assets/profileImage.png',
                        alignment: Alignment.center,
                      ),
                    ),

                    // Texte de bienvenue
                    Container(
                      margin: const EdgeInsets.only(top: 52),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Bienvenue',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Champ email
                    Container(
                      margin: const EdgeInsets.only(top: 22),
                      child: TextFormField(
                        controller: emailInput,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adresse Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un email';
                          }
                          if (!value.contains('@')) {
                            return 'Veuillez entrer un email valide';
                          }
                          return null;
                        },
                      ),
                    ),

                    // Champ mot de passe
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: TextFormField(
                        controller: passwordInput,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Mot de passe',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un mot de passe';
                          }
                          return null;
                        },
                      ),
                    ),

                    // Bouton de connexion
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          // Ajouter la logique de connexion ici
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff006FFD),
                          textStyle: TextStyle(color: Colors.white, fontSize: 48),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text(
                          'Connexion',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    // Diviseur

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailInput.dispose();
    passwordInput.dispose();
    super.dispose();
  }
}