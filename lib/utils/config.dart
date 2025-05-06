class AppConfig {
  // URL de l'API utilisée en mode debug et en production
  static const String baseUrl = 'http://examen-apimobile-marqau-8dc3f4-192-168-136-2.traefik.me/api';
  static const String ordersEndpoint = '$baseUrl/addCommande';
  
  // Configuration pour autoriser le trafic non sécurisé (HTTP)
  static const bool allowInsecureConnections = true;
}
