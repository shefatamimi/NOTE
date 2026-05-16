import 'package:flutter/material.dart';

import '../models/login_models.dart';
import '../service/Login_Service.dart';
import 'login_screen.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.user});

  final LoginModels user;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmHidden = true;

  @override
  void initState() {
    super.initState();

    emailController.text = widget.user.email;
    passwordController.text = widget.user.password;
    confirmPasswordController.text = widget.user.password;
  }

  Future<void> updateLogin() async {
    final updated = LoginModels(
      id: widget.user.id,
      email: emailController.text,
      password: passwordController.text,
    );

    await LoginService().updateLogin(updated);

    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Edit Profile'),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 40),

            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.teal,

                child: Text(
                  widget.user.email[0].toUpperCase(),

                  style: TextStyle(
                    fontSize: 65,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 15),

            Center(
              child: Text(
                widget.user.email.split('@')[0],

                style: TextStyle(
                  fontSize: 25,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10),

              child: Text(
                'Email',

                style: TextStyle(
                  fontSize: 17,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 5),

            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10),

              child: TextField(
                controller: emailController,

                keyboardType: TextInputType.emailAddress,

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  suffixIcon: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10),

              child: Text(
                'Password',

                style: TextStyle(
                  fontSize: 17,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 5),

            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10),

              child: TextField(
                controller: passwordController,

                keyboardType:
                TextInputType.visiblePassword,

                obscureText: isPasswordHidden,

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),

                    onPressed: () {
                      setState(() {
                        isPasswordHidden =
                        !isPasswordHidden;
                      });
                    },
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10),

              child: Text(
                'Confirm Password',

                style: TextStyle(
                  fontSize: 17,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 5),

            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10),

              child: TextField(
                controller: confirmPasswordController,

                keyboardType:
                TextInputType.visiblePassword,

                obscureText: isConfirmHidden,

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),

                    onPressed: () {
                      setState(() {
                        isConfirmHidden =
                        !isConfirmHidden;
                      });
                    },
                  ),
                ),
              ),
            ),

            SizedBox(height: 40),

            Center(
              child: GestureDetector(
                onTap: () async {

                  if (passwordController.text != confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                    return;
                  }

                  final updated = LoginModels(
                    id: widget.user.id,
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  final result = await LoginService().updateLogin(updated);

                  if (result > 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully')),
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(
                          title: '',
                          email: '',
                          password: '',
                        ),
                      ),
                          (route) => true,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Update failed')),
                    );
                  }
                },

                child: Container(
                  height: 55,
                  width: 200,

                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),

                  child: Center(
                    child: Text(
                      'Update Profile',

                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}