class ApiConstants {
  // 📱 IMPORTANTE: Como estás en web (Chrome), usa localhost
  static const String baseUrl = 'http://localhost:3000/api_v1';
  
  // Si pruebas en celular físico, usa esta (la IP de tu red)
  // static const String baseUrl = 'http://10.1.195.29:3000/api_v1';
  
  static const String loginEndpoint = '/apiUserLogin';
  static const String createRoleEndpoint = '/role';
  
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String authorization = 'Authorization';
}