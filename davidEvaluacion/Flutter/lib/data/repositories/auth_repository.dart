import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConstants.registerEndpoint,
        body: request.toJson(),
        withAuth: false,
      );

      return RegisterResponse.fromJson(response);
    } catch (e) {
      throw Exception('Error en registro: ${e.toString()}');
    }
  }

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConstants.loginEndpoint,
        body: request.toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response);

      // Guardar token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', loginResponse.token);

      return loginResponse;
    } catch (e) {
      throw Exception('Error en login: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
