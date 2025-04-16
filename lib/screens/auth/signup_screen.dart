// signup_screen.dart

import 'package:discount_portal_app/screens/company/company_home.dart';
import 'package:discount_portal_app/screens/employee/employee_home.dart';
import 'package:discount_portal_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _userType = 'employee';
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _userType,
      );

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) =>
                    _userType == 'employee'
                        ? const EmployeeHomeScreen()
                        : const CompanyHomeScreen(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _userType,
                  decoration: const InputDecoration(labelText: 'User Type'),
                  items: const [
                    DropdownMenuItem(
                      value: 'employee',
                      child: Text("Employee"),
                    ),
                    DropdownMenuItem(value: 'company', child: Text("Company")),
                  ],
                  onChanged: (value) => setState(() => _userType = value!),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Please enter your email' : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator:
                      (value) =>
                          value!.length < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                  validator:
                      (value) =>
                          value!.isEmpty
                              ? 'Please confirm your password'
                              : null,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _signUp,
                      child: const Text("Sign Up"),
                    ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Already have an account? Log in"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
