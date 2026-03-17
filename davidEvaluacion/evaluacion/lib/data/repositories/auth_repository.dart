import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/role_request.dart';
import '../models/role.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

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

  Future<Role> createRole(RoleRequest request) async {
    try {
      // IMPORTANTE: Crear rol NO requiere token (withAuth: false)
      final response = await _apiService.post(
        ApiConstants.createRoleEndpoint,
        body: request.toJson(),
        withAuth: false,  // ¡Cambiado a false! No necesita token
      );

      return Role.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear rol: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}