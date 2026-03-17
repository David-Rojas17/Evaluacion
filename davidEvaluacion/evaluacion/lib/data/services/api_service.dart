import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';

class ApiService {
  final http.Client _client = http.Client();

  Future<Map<String, String>> _getHeaders({bool withAuth = false}) async {
    final headers = {
      ApiConstants.contentType: ApiConstants.applicationJson,
    };

    if (withAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        headers[ApiConstants.authorization] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool withAuth = false,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(withAuth: withAuth);

      print('🌐 POST Request: $url');
      print('📤 Headers: $headers');
      print('📦 Body: ${json.encode(body)}');

      final response = await _client.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    try {
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        // Intentar obtener el mensaje de error de la respuesta
        final errorMessage = responseData['message'] ?? 
                            responseData['error'] ?? 
                            'Error ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Error al procesar la respuesta del servidor');
      }
      rethrow;
    }
  }
}