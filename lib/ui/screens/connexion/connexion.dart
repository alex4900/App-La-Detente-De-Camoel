import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/Auth.dart';
import '../HomePageScreen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Pour garder le token d'authentification

class Connexion extends StatefulWidget {
  const Connexion({Key? key}) : super(key: key);

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final TextEditingController emailInput = TextEditingController();
  final TextEditingController passwordInput = TextEditingController();
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await AuthService.login(emailInput.text, passwordInput.text);

      switch (response.statusCode) {
        case 200:
          final responseData = jsonDecode(response.body);

          // Stocker le token dans SharedPreferences
          String token = responseData['access_token'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          // Vérifier le rôle de l'utilisateur
          String role = await AuthService.getUserRole();
          if (role == 'Serveur') {
            // Puis changer de page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePageScreen(initialIndex: 1),
              ),
            );
          } else {
            showErrorDialog('Vous n\'êtes pas autorisé à accéder à cette application.');
            await prefs.remove('auth_token'); // Supprimer le token si l'utilisateur n'est pas autorisé
          }
          break;

        case 400:
          showErrorDialog('Requête invalide. Veuillez vérifier les données saisies.');
          break;

        case 401:
          showErrorDialog('Email ou mot de passe incorrect.');
          break;

        case 403:
          showErrorDialog('Vous n\'êtes pas autorisé à accéder à cette application.');
          break;

        case 404:
          showErrorDialog('Ressource introuvable. Veuillez réessayer plus tard.');
          break;

        case 422:
          final errorData = jsonDecode(response.body);
          showErrorDialog(errorData['message'] ?? 'Données invalides.');
          break;

        case 429:
          showErrorDialog('Trop de requêtes. Veuillez réessayer plus tard.');
          break;

        case 500:
          showErrorDialog('Erreur interne du serveur. Veuillez réessayer plus tard.');
          break;

        case 503:
          showErrorDialog('Service temporairement indisponible. Veuillez réessayer plus tard.');
          break;

        case 504:
          showErrorDialog('Le serveur ne répond pas. Veuillez réessayer plus tard.');
          break;

        default:
          showErrorDialog('Erreur inattendue : ${response.statusCode}');
          break;
      }

    } catch (e) {
      showErrorDialog("Connexion à la base de données impossible, essayer d'activer le VPN ou de lancez le serveur correctement.");
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
