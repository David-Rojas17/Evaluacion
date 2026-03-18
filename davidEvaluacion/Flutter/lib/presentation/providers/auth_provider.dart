import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/login_request.dart';
import '../../data/models/login_response.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;
  LoginResponse? _loginResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginResponse? get loginResponse => _loginResponse;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Ahora LoginRequest espera apiUser y apiPassword
      final request = LoginRequest(
        apiUser: email, // El email del usuario
        apiPassword: password, // La contraseña
      );
      _loginResponse = await _repository.login(request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
