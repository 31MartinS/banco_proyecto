import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/api_service.dart';

class TransactionController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<TransactionModel> transactions = [];

  Future<void> fetchTransactions(String userId, String idToken) async {
    try {
      final response = await _apiService.getTransactions(userId, idToken);
      transactions = response
          .map<TransactionModel>((json) => TransactionModel.fromJson(json))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error al obtener transacciones: $e');
    }
  }
}
