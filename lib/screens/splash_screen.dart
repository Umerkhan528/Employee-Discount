// splash_screen.dart

import 'package:flutter/material.dart';
import 'package:discount_portal_app/screens/auth/login_screen.dart';
import 'package:discount_portal_app/screens/company/company_home.dart';
import 'package:discount_portal_app/screens/employee/employee_home.dart';
import 'package:discount_portal_app/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));

    final userData = await _authService.getCurrentUserData();

    if (userData != null) {
      final role = userData['role'];

      if (role == 'company') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CompanyHomeScreen()),
        );
      } else if (role == 'employee') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmployeeHomeScreen()),
        );
      } else {
        await _authService.signOut();
        _goToLogin();
      }
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.card_giftcard, size: 64, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'EmployeePerks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
