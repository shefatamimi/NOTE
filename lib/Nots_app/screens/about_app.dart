import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
        backgroundColor: Colors.teal,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            Center(
              child: Icon(
                Icons.note_alt,
                size: 80,
                color: Colors.teal,
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Notes App',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'This is a simple Notes App built using Flutter. '
                  'It allows users to create, edit, delete, and organize their notes easily.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            const Text(
              'Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text('• Add Notes'),
            const Text('• Edit Notes'),
            const Text('• Delete Notes'),
            const Text('• Search Notes'),

            const SizedBox(height: 20),

            const Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            const Text(
              'Developed by: Shefa_Al_Tamimi',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}