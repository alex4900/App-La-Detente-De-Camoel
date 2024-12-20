import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../data/services/api_service.dart';
import '../HomePageScreen.dart';

class Connexion extends StatefulWidget {
  const Connexion({Key? key}) : super(key: key);

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final TextEditingController emailInput = TextEditingController();
  final TextEditingController passwordInput = TextEditingController();
  bool isLoading = false; // Ajout d'un état de chargement

  void login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.login(emailInput.text, passwordInput.text);

      if (response.statusCode == 200) {
        // Supposons que le serveur renvoie un token ou un succès
        final responseData = jsonDecode(response.body);

        // Vous pouvez enregistrer le token ici si nécessaire
        // Exemple : SharedPreferences pour un stockage local
        // String token = responseData['token'];

        // Redirection vers la page d'accueil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePageScreen(initialIndex: 1),
          ),
        );
      } else if (response.statusCode == 422) {
        // Erreur de validation
        final errorData = jsonDecode(response.body);
        showErrorDialog(errorData['message'] ?? 'Données invalides');
      } else {
        // Autres erreurs
        showErrorDialog('Erreur : ${response.statusCode}');
      }
    } catch (e) {
      showErrorDialog('Une erreur est survenue. Veuillez réessayer.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
                              height: constraints.maxHeight * 0.3,
                              child: Image.asset(
                                'images/logoConnexion.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Bienvenue',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextFormField(
                          controller: emailInput,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Adresse Email',
                          ),
                        ),

                        const SizedBox(height: 24),

                        TextFormField(
                          controller: passwordInput,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Mot de passe',
                          ),
                        ),

                        const SizedBox(height: 24),

                        isLoading
                            ? const Center(
                          child: CircularProgressIndicator(),
                        )
                            : ElevatedButton(
                          onPressed: login,
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
