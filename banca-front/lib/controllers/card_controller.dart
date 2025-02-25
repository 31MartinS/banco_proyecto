import 'package:flutter/material.dart';
import '../models/card.dart';
import '../services/api_service.dart';

class CardController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<CardModel> cards = [];
  String? userId; // Se establecerá al cargar el usuario

  // Obtiene todas las tarjetas del usuario
  Future<void> fetchCards(String idToken) async {
    try {
      if (userId == null) {
        print('No hay userId definido');
        return;
      }
      final response = await _apiService.getCards(userId!, idToken);
      cards = response.map<CardModel>((json) => CardModel.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      print('Error al obtener tarjetas: $e');
    }
  }

  // Agrega una nueva tarjeta
  Future<bool> addCard({
    required String cardNumber,
    required String expiryDate,
    required String cardholderName,
    required String idToken,
  }) async {
    try {
      if (userId == null) {
        print('No hay userId definido');
        return false;
      }
      Map<String, dynamic> cardData = {
        'userId': userId, // Se utiliza el userId almacenado
        'cardNumber': cardNumber,
        'expiryDate': expiryDate,
        'cardholderName': cardholderName,
      };

      final response = await _apiService.addCard(cardData, idToken);
      if (response['message'] != null) {
        await fetchCards(idToken);
        return true;
      }
      return false;
    } catch (e) {
      print('Error al agregar tarjeta: $e');
      return false;
    }
  }

  // Elimina una tarjeta
  Future<bool> deleteCard({
    required String cardId,
    required String idToken,
  }) async {
    try {
      final response = await _apiService.deleteCard(cardId, idToken);
      if (response['message'] != null) {
        await fetchCards(idToken);
        return true;
      }
      return false;
    } catch (e) {
      print('Error al eliminar tarjeta: $e');
      return false;
    }
  }

  // Congela una tarjeta
  Future<bool> freezeCard({
    required String cardId,
    required String idToken,
  }) async {
    try {
      final response = await _apiService.freezeCard(cardId, idToken);
      if (response['message'] != null) {
        await fetchCards(idToken);
        return true;
      }
      return false;
    } catch (e) {
      print('Error al congelar tarjeta: $e');
      return false;
    }
  }

  // Descongela una tarjeta
  Future<bool> unfreezeCard({
    required String cardId,
    required String idToken,
  }) async {
    try {
      final response = await _apiService.unfreezeCard(cardId, idToken);
      if (response['message'] != null) {
        await fetchCards(idToken);
        return true;
      }
      return false;
    } catch (e) {
      print('Error al descongelar tarjeta: $e');
      return false;
    }
  }
}
