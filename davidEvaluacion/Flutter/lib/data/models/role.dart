class Role {
  final int? id; // ¿Tu API devuelve 'id' o 'roles_id'?
  final String name; // La API devuelve 'name'
  final String? description; // La API devuelve 'description'
  final String? createdAt; // ¿Cómo se llama este campo en la respuesta?
  final String? updatedAt; // ¿Cómo se llama este campo en la respuesta?

  Role({
    this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'], // Ajusta según lo que devuelva tu API (podría ser 'roles_id')
      name: json['name'] ?? '', // La API devuelve 'name'
      description: json['description'], // La API devuelve 'description'
      createdAt: json['created_at'] ?? json['createAt'], // Ajusta según tu API
      updatedAt: json['updated_at'] ?? json['updateAt'], // Ajusta según tu API
    );
  }
}
