class RoleRequest {
  final String name; // Cambiado de rolesName a name
  final String? description; // Cambiado de rolesDescription a description

  RoleRequest({required this.name, this.description});

  Map<String, dynamic> toJson() {
    return {
      'name': name, // Importante: la API espera 'name'
      'description': description, // Importante: la API espera 'description'
    };
  }
}
