import 'package:flutter/material.dart';
import '../core/constants/app_routes.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/create_role_screen.dart';
import '../presentation/screens/home_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case AppRoutes.createRole:
        return MaterialPageRoute(builder: (_) => CreateRoleScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}