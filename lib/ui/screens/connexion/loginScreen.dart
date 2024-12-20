import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:android_detente_camoel/data/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _response = "";

  Future<void> _login() async {
    try {
      final response = await ApiService.login(
        _emailController.text,
        _passwordController.text,
      );
      if (response.statusCode == 200) {
        setState(() {
          _response = json.decode(response.body).toString();
        });
      } else {
        setState(() {
          _response = "Erreur : ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      setState(() {
        _response = "Erreur : $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Mot de passe"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("Se connecter"),
            ),
            SizedBox(height: 20),
            Text("Réponse API :"),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
