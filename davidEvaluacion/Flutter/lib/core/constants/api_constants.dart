import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  // URL base dinámico según plataforma
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api_v1';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api_v1';
    }
    if (Platform.isIOS) {
      return 'http://localhost:3000/api_v1';
    }
    return 'http://localhost:3000/api_v1';
  }

  // Si pruebas con API real en otra IP, actualiza aquí
  // static const String baseUrl = 'http://192.168.1.xxx:3000/api-crud';

  static const String loginEndpoint = '/apiUserLogin';
  static const String registerEndpoint = '/apiUser';

  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String authorization = 'Authorization';
}
