import 'package:flutter/material.dart';
import 'package:note/Nots_app/screens/regester_screen.dart';
import '../service/Login_Service.dart';
import 'Mynot_Screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title, required this.email, required this.password});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
  final String title;
  final String email;
  final String password;
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }


  Future<bool> login() async {
    final email = emailController.text;
    final password =  passController.text;
    final login = await LoginService().checkLogin(email, password);


    if (login != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyNote(),
        ),
      );
      return true;
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed'),
        ),);
      return false;


    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body:
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 190),

            Text('Login Her !',style: TextStyle(
              fontSize: 40,
              color: Colors.teal,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black,
                  ),
                ],

              fontWeight: FontWeight.bold
            ),
        ),


            const SizedBox(height: 20),
            const Text("Your Ideas Are Waiting 📝"),

            const SizedBox(height: 70),

            // email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
              key: Key('loginButtonKey'),
              style: ElevatedButton.styleFrom(

                minimumSize: Size(200, 50),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

              ), onPressed: () async {
                if (emailController.text.isEmpty || passController.text.isEmpty)  {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                        ),);
                  return;
                }
                bool loginSuccess = await login();
                if (loginSuccess) {

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login successful'),
                  ),);}
            }, child: const Text('Sign In',style: TextStyle(
              color: Colors.black87,
              fontSize: 20
            ),),

            ),


            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not yet a member? ',style: TextStyle(color: Colors.black38,fontSize: 15),),
                InkWell(child: const Text('sign up now',
                    style: TextStyle(color: Colors.black87,fontSize: 15),

                ),
                  onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegesterScreen(
                        email: emailController.text,
                        password: passController.text,
                        confirmPassword: passController.text,
                    )
                  ),);
                  }
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}