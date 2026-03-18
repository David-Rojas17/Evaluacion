import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/register_request.dart';

class RegisterProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<bool> register(
    String user,
    String password,
    int status,
    int role,
  ) async {
    // Asegurar valores válidos por defecto
    final normalizedStatus = (status == 1 ? 1 : 0);
    final normalizedRole = (role == 1 || role == 2) ? role : 2;
    // 1=admin, 2=user
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final request = RegisterRequest(
        user: user,
        password: password,
        status: normalizedStatus,
        role: normalizedRole,
      );

      final response = await _repository.register(request);
      _successMessage = response.message ?? 'Usuario registrado exitosamente';
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

  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }
}
