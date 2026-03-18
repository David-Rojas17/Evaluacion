class LoginResponse {
  final String token; // Solo necesitamos el token que devuelve tu API

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '', // Tu API devuelve solo el token
    );
  }
}
