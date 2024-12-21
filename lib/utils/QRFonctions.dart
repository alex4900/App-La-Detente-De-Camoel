import 'dart:convert'; // Nécessaire pour la conversion JSON
import 'package:http/http.dart' as http;
import 'config.dart'; // Import de la configuration pour l'URL de base

/// Vérifie si un QR code correspond à une réservation valide dans la base de données.
Future<Map<String, dynamic>> checkReservation(String qrCode) async {
  var headers = {
    'Accept': 'application/json',
  };

  // Construire l'URL de la requête
  String url = '${AppConfig.baseUrl}/reservation/qrCode/?QrCode=$qrCode';

  var request = http.Request('GET', Uri.parse(url));
  request.body = '''''';
  request.headers.addAll(headers);

  try {
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Décoder la réponse JSON
      String responseData = await response.stream.bytesToString();
      return jsonDecode(responseData);
    }
    else if(response.statusCode == 404) {

      return {};
    }
    else {
      throw Exception('Erreur serveur: ${response.reasonPhrase}');
    }
  } catch (e) {
    throw Exception('Erreur de connexion: $e');
  }
}
