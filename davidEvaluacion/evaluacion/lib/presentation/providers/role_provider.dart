import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/role_request.dart';
import '../../data/models/role.dart';

class RoleProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  
  bool _isLoading = false;
  String? _errorMessage;
  Role? _createdRole;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Role? get createdRole => _createdRole;

  Future<bool> createRole(String name, String? description) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // RoleRequest ahora espera name y description
      final request = RoleRequest(
        name: name,  // El nombre del rol
        description: description,  // La descripción (puede ser null)
      );
      
      print('🎯 Creando rol con nombre: $name');
      _createdRole = await _repository.createRole(request);
      print('✅ Rol creado exitosamente: ${_createdRole?.name}');
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error al crear rol: $e');
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _createdRole = null;
    _errorMessage = null;
    notifyListeners();
  }
}