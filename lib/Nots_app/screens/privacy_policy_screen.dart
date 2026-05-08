import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Colors.teal,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: const Text(
          "Privacy Policy\n\n"
              "This Notes App respects your privacy.\n\n"
              "1. Data Collection\n"
              "- We store notes and email if login is used.\n\n"
              "2. Usage\n"
              "- Data is used only to run the app.\n\n"
              "3. Sharing\n"
              "- We do not share any data with third parties.\n\n"
              "4. Security\n"
              "- We try to keep your data safe.\n\n"
              "5. Deletion\n"
              "- You can delete your data anytime.\n\n"
              "6. Contact\n"
              "- Contact developer for any questions.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}