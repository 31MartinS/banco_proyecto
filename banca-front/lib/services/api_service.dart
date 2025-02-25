import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:3000/api';

  // Autenticación
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  // Obtener datos de usuario
  Future<Map<String, dynamic>> getUser(String id, String idToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );
    return jsonDecode(response.body);
  }

  // Tarjetas
  Future<List<dynamic>> getCards(String userId, String idToken) async {
    print('🔹 Token de autenticación: $idToken');
    final response = await http.get(
      Uri.parse('$baseUrl/cards/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> addCard(Map<String, dynamic> cardData, String idToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cards'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode(cardData),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> deleteCard(String cardId, String idToken) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cards/$cardId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> freezeCard(String cardId, String idToken) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cards/$cardId/freeze'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );
    return jsonDecode(response.body);
  }

  // Pagos
  Future<Map<String, dynamic>> makePayment(Map<String, dynamic> paymentData, String idToken) async {
    final url = Uri.parse('$baseUrl/payments');

    try {
      print('🔹 Enviando solicitud de pago a: $url');
      print('🔹 Datos enviados: $paymentData');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode(paymentData),
      );

      final responseData = jsonDecode(response.body);
      print('🟢 Respuesta del servidor: $responseData');

      return responseData;
    } catch (e) {
      print('❌ Error en la solicitud HTTP: $e');
      return {'error': 'Error en la solicitud de pago'};
    }
  }


  Future<List<dynamic>> getTransactions(String userId, String idToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/transactions/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );

    final responseData = jsonDecode(response.body);
    print('🟢 Respuesta del servidor: $responseData');

    // Si `responseData` ya es una lista, retornarla directamente
    if (responseData is List) {
      return responseData; // ✅ Retorna la lista de transacciones correctamente
    } else if (responseData is Map && responseData.containsKey("transactions")) {
      return responseData["transactions"]; // ✅ Extraer la lista si viene dentro de un Map
    } else {
      print('❌ Error: Respuesta inesperada del servidor');
      return []; // ✅ Evitar errores devolviendo una lista vacía
    }
  }




  // Notificaciones
  Future<List<dynamic>> getNotifications(String userId, String idToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );
    return jsonDecode(response.body);
  }
  Future<Map<String, dynamic>> unfreezeCard(String cardId, String idToken) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cards/$cardId/unfreeze'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );
    return jsonDecode(response.body);
  }
}
