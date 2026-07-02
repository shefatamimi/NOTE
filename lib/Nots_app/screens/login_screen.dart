import 'package:flutter/material.dart';
import 'package:note/Nots_app/screens/regester_screen.dart';
import 'package:note/Nots_app/screens/home_screen.dart';
import '../models/login_models.dart';
import '../service/Login_Service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key,
    required this.title,
    required this.email,
    required this.password
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
  final String title;
  final String email;
  final String password;
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  Future<bool> login() async {
    final email = emailController.text;
    final password = passController.text;
    final login = await LoginService().checkLogin(email, password);

    if (!mounted) return false;

    if (login != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: login),
        ),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 190),
            Text(
              'Login Here!',
              style: TextStyle(
                fontSize: 40,
                color: Colors.teal,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 2,
                    color: theme.brightness == Brightness.dark ? Colors.white24 : Colors.black26,
                  ),
                ],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Your Ideas Are Waiting 📝",
              style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 70),
            // email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    if (theme.brightness == Brightness.light)
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, spreadRadius: 1)
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            // password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    if (theme.brightness == Brightness.light)
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, spreadRadius: 1)
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: passController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            // button
            ElevatedButton(
              key: const Key('loginButtonKey'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (emailController.text.isEmpty || passController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }
                await login();
              },
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not yet a member? ',
                  style: TextStyle(color: theme.textTheme.bodySmall?.color),
                ),
                InkWell(
                  child: Text(
                    'sign up now',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegesterScreen(
                          email: emailController.text,
                          password: passController.text,
                          confirmPassword: passController.text,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
