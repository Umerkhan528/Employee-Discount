// login_screen.dart
import 'package:discount_portal_app/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../employee/employee_home.dart';
import '../company/company_home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum UserType { employee, company }

class _LoginScreenState extends State<LoginScreen> {
  String email = '', password = '';
  UserType? userType = UserType.employee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton<UserType>(
              value: userType,
              onChanged: (val) => setState(() => userType = val),
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
            TextField(
              onChanged: (val) => email = val,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              onChanged: (val) => password = val,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signIn(email, password);
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
              },
              child: Text("Login"),
            ),
            TextButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SignUpScreen()),
                  ),
              child: Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
