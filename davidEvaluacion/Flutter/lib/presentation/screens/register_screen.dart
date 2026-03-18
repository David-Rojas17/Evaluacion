import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/register_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../../core/utils/validators.dart';
import '../../core/constants/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _status = 1; // 1 = Active, 0 = Inactive
  int _role = 2; // 1 = admin, 2 = user
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Consumer<RegisterProvider>(
            builder: (context, registerProvider, child) {
              if (registerProvider.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(registerProvider.errorMessage!),
                      backgroundColor: Colors.red,
                    ),
                  );
                  registerProvider.clearError();
                });
              }

              if (registerProvider.successMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(registerProvider.successMessage!),
                      backgroundColor: Colors.green,
                    ),
                  );
                  registerProvider.clearSuccess();
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                });
              }

              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Crea tu cuenta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Completa el formulario para registrarte.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: _userController,
                      label: 'Usuario (email)',
                      hint: 'ejemplo@correo.com',
                      prefixIcon: Icons.person,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      enabled: !registerProvider.isLoading,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Contraseña',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: Validators.validatePassword,
                      enabled: !registerProvider.isLoading,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('Active')),
                        DropdownMenuItem(value: 0, child: Text('Inactive')),
                      ],
                      onChanged: registerProvider.isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _status = value ?? 1;
                              });
                            },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _role,
                      decoration: const InputDecoration(
                        labelText: 'Rol',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona un rol';
                        }
                        return null;
                      },
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('admin')),
                        DropdownMenuItem(value: 2, child: Text('user')),
                      ],
                      onChanged: registerProvider.isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _role = value ?? 1;
                              });
                            },
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Registrar',
                      isLoading: registerProvider.isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await registerProvider.register(
                            _userController.text.trim(),
                            _passwordController.text,
                            _status,
                            _role,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      },
                      child: const Text('¿Ya tienes cuenta? Iniciar sesión'),
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
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
