import 'package:flutter/material.dart';

class BackupRestore extends StatelessWidget {
  const BackupRestore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Backup & Restore"),
        backgroundColor: Colors.teal,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [

            Text(
              "Backup & Restore",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            Text(
              "• Backup your notes to keep them safe.\n\n"
                  "• Restore them anytime if you lose data.\n\n"
                  "• Data is stored locally in the device.\n\n"
                  "• Always keep a backup to avoid data loss.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}