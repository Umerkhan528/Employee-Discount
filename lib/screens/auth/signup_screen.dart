// signup_screen.dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../employee/employee_home.dart';
import '../company/company_home.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

enum UserType { employee, company }

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  UserType userType = UserType.employee;

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      final user = await AuthService().signUp(email, password);
      if (user != null) {
        if (userType == UserType.employee) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => EmployeeHomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => CompanyHomeScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Signup failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButton<UserType>(
                value: userType,
                onChanged: (val) => setState(() => userType = val!),
                items: [
                  DropdownMenuItem(
                    value: UserType.employee,
                    child: Text("Employee"),
                  ),
                  DropdownMenuItem(
                    value: UserType.company,
                    child: Text("Company"),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter email' : null,
                onChanged: (val) => email = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator:
                    (val) => val!.length < 6 ? 'Password too short' : null,
                onChanged: (val) => password = val,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: signUp, child: Text("Sign Up")),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Already have an account? Log in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
