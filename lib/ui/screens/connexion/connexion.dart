import 'package:flutter/material.dart';
import '../HomePageScreen.dart';

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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Center(
                            child: SizedBox(
                              height: constraints.maxHeight * 0.3, // Hauteur adaptative
                              child: Image.asset(
                                'images/logoConnexion.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Texte de bienvenue
                        const Text(
                          'Bienvenue',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Champ email
                        TextFormField(
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

                        const SizedBox(height: 24),

                        // Champ mot de passe
                        TextFormField(
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

                        const SizedBox(height: 24),

                        // Bouton de connexion
                        ElevatedButton(
                          onPressed: () {
                            // Change l'index dans HomePageScreen pour afficher Page1
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePageScreen(initialIndex: 1),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff006FFD),
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text(
                            'Connexion',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
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