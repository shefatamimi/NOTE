import 'package:flutter/material.dart';
import '../models/login_models.dart';
import '../service/Login_Service.dart';
import 'login_screen.dart';

class RegesterScreen extends StatefulWidget {
  const RegesterScreen({super.key, required this.email, required this.password, required this.confirmPassword});

  @override
  State<RegesterScreen> createState() => _RegesterScreenState();
  final String email;
  final String password;
  final String confirmPassword;
}

class _RegesterScreenState extends State<RegesterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  Future<bool> saveUser() async {
    if (passController.text != confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return false;
    }
    if (emailController.text.isEmpty || passController.text.isEmpty || confirmPassController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return false;
    }
    final email = emailController.text;
    final password = passController.text;

    final user = LoginModels(email: email, password: password);
    final result = await LoginService().createLogin(user);
    return result > 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 30,
                  color: theme.textTheme.headlineMedium?.color ?? Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Create an account to start saving\nand organizing your notes easily",
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 15),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.teal, width: 2.0),
                    ),
                    filled: true,
                    fillColor: theme.cardColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.teal, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.cardColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: confirmPassController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.teal, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.cardColor,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                key: const Key('registerButtonKey'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  bool success = await saveUser();
                  if (success) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration successful')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(
                        key: Key('loginScreenKey'),
                        title: 'Login',
                        email: '',
                        password: '',
                      ),
                    ),
                  );
                },
                child: Text(
                  'Already have an account?',
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
