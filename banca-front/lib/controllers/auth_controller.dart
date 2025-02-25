import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  UserModel? currentUser;
  String? idToken;

  Future<void> refreshToken() async {
    idToken = await FirebaseAuth.instance.currentUser?.getIdToken(true);
    print("🟢 Nuevo token obtenido: $idToken");
  }

  // Inicio de sesión usando Firebase Auth y backend
  Future<bool> login(String email, String password) async {
    try {
      // Autenticación con Firebase
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      await refreshToken();
      //idToken = await credential.user?.getIdToken();

      // Llamada al backend para obtener datos del usuario
      final result = await _apiService.login(email, password);
      if (result['message'] == 'Inicio de sesión exitoso.') {
        currentUser = UserModel.fromJson(result['user']);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error en login: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final result = await _apiService.register(name, email, password);
      return result['message'] == 'Usuario registrado con éxito.';
    } catch (e) {
      print('Error en registro: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    currentUser = null;
    idToken = null;
    notifyListeners();
  }
}
