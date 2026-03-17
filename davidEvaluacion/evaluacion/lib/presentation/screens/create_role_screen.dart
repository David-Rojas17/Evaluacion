import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/role_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../../core/utils/validators.dart';
import '../../core/constants/app_routes.dart';

class CreateRoleScreen extends StatelessWidget {
  CreateRoleScreen({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Rol'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Consumer<RoleProvider>(
            builder: (context, roleProvider, child) {
              // Si hay error, mostrarlo
              if (roleProvider.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(roleProvider.errorMessage!),
                      backgroundColor: Colors.red,
                    ),
                  );
                  roleProvider.clearError();
                });
              }

              // Si se creó el rol exitosamente, navegar a Home
              if (roleProvider.createdRole != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                });
              }

              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Completa los datos del nuevo rol',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: _nameController,
                      label: 'Nombre del Rol',
                      hint: 'Ej: Administrador, Usuario, Editor...',
                      prefixIcon: Icons.badge,
                      validator: (value) => Validators.validateRequired(
                        value, 
                        'El nombre del rol'
                      ),
                      enabled: !roleProvider.isLoading,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _descriptionController,
                      label: 'Descripción (opcional)',
                      hint: 'Describe el propósito del rol',
                      prefixIcon: Icons.description,
                      enabled: !roleProvider.isLoading,
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Crear Rol',
                      isLoading: roleProvider.isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await roleProvider.createRole(
                            _nameController.text.trim(),
                            _descriptionController.text.trim().isNotEmpty 
                                ? _descriptionController.text.trim() 
                                : null,
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
  }
}