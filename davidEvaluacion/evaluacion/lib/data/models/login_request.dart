class LoginRequest {
  final String apiUser;  // Cambiado de email a apiUser
  final String apiPassword;  // Cambiado de password a apiPassword

  LoginRequest({
    required this.apiUser,
    required this.apiPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'api_user': apiUser,  // Importante: el campo se llama 'api_user'
      'api_password': apiPassword,  // Importante: el campo se llama 'api_password'
    };
  }
}