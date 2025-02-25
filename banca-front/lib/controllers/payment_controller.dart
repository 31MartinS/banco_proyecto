import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PaymentController with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Future<bool> makePayment(Map<String, dynamic> paymentData, String idToken) async {
    try {
      print('🔹 Enviando datos de pago: $paymentData'); // <-- Imprime los datos enviados

      final response = await _apiService.makePayment(paymentData, idToken);

      print('🟢 Respuesta del servidor: $response'); // <-- Imprime la respuesta

      return response['message'] != null;
    } catch (e) {
      print('❌ Error al realizar pago: $e');
      return false;
    }
  }
}
