class RegisterRequest {
  final String user;
  final String password;
  final int status;
  final int role;

  RegisterRequest({
    required this.user,
    required this.password,
    required this.status,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {'user': user, 'password': password, 'status': status, 'role': role};
  }
}
