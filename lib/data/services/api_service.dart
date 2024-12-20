import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.147.10/api";

  static Future<http.Response> login(String email, String password) async {
    var url = Uri.parse("$baseUrl/login");
    var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}), // Encode la Map en JSON
    );
    return response;
  }
}
