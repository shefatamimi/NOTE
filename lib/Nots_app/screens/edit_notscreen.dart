import 'package:flutter/material.dart';
import '../models/note_models.dart';
import '../service/note_service.dart';

class EditNot extends StatefulWidget {
  final NoteModels note;

  const EditNot({super.key, required this.note});

  @override
  State<EditNot> createState() => _EditNotState();
}

class _EditNotState extends State<EditNot> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    descriptionController = TextEditingController(text: widget.note.description);
    selectedDate = widget.note.date ?? DateTime.now();
  }

  Future<void> updateNote() async {
    final updated = NoteModels(
      id: widget.note.id,
      title: titleController.text,
      description: descriptionController.text,
      date: selectedDate,
      isCompleted: widget.note.isCompleted,
    );

    await NoteService().updateNots(updated);

    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        backgroundColor: Colors.teal,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Title',
                  contentPadding: EdgeInsets.all(16),
                  enabledBorder: OutlineInputBorder(
                  ),
                  border: OutlineInputBorder(


                  ),
                ),

              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,
              maxLines: 18,
              decoration: const InputDecoration(hintText: 'Description'),

            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2015),
                  lastDate: DateTime(2101),
                );

                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Text(
                '📅 ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: updateNote,
              child: const Text("Update",style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}