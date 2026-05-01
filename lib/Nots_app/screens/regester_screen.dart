import 'package:flutter/material.dart';
import '../models/Login_models.dart';
import '../service/Login_Service.dart';
import 'loginscreen.dart';

class RegesterScreen extends StatefulWidget {
  RegesterScreen({super.key, required this.email, required this.password, required this.confirmPassword});

  @override
  State<RegesterScreen> createState() => _RegesterScreenState();
  final String email;
  final String password;
  final String confirmPassword;
}
class _RegesterScreenState extends State<RegesterScreen> {
  @override
  void initState() {
    super.initState();

  }
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  Future<bool> saveUser() async {
    if (passController.text != confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),

        ),
      );
      return false;
    }
    if (emailController.text.isEmpty || passController.text.isEmpty
        || confirmPassController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return false;
    }
    final email = emailController.text;
    final password = passController.text;

    final user = LoginModels(
      email: email,
      password: password,
    );

    final result = await LoginService().createLogin(user);
    return result > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Regester',style: TextStyle(
            color: Colors.black54,
            fontSize: 20
        ),
        ),
        backgroundColor: Colors.teal,
      ),
      body:
      SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Text('Create Account',style: TextStyle(fontSize: 30,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text("Create an account to start saving\nand organizing your notes easily",style: TextStyle(
                  color: Colors.black38,
                  fontSize: 15
              ),),
               SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.teal,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),

                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: passController,
                    obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'password',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.teal,
                        width: 2.0,
                      )
                    ),
                    enabledBorder: OutlineInputBorder(


                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,

                  )

                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: confirmPassController,
                    obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'confirm password',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.teal,
                        width: 2.0,
                      )
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  )

                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                key: Key('registerButtonKey'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text('Register',style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20
                ),),
                onPressed: () async{
                    bool success = await saveUser();
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration successful'),
                        ),
                      );
                      Navigator.pop(context);
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration failed'),
                        ),
                      );
                    }

                },


              ),
              SizedBox(height: 40),
              InkWell(
                child: Text('Already have an account?',style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15
                ),),
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
                }
              ),

            ],
          ),
        ),
      ),




    );

  }
}
