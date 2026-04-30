import 'package:flutter/material.dart';
import '../models/note_models.dart';
import '../service/note_service.dart';

class Addnotes extends StatefulWidget {
  const Addnotes({
    super.key,
    required this.title,
    required this.description,
    required this.selectedDate,
  });

  final String title;
  final String description;
  final DateTime selectedDate;

  @override
  State<Addnotes> createState() => _AddnotesState();
}

class _AddnotesState extends State<Addnotes> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    descriptionController.text = widget.description;
    selectedDate = widget.selectedDate;
  }

  Future<void> _selectDate(BuildContext context) async {
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
  }

  Future<void> saveNote() async {
    final note = NoteModels(
      title: titleController.text,
      description: descriptionController.text,
      date: selectedDate,
      isCompleted: false,
    );

    Navigator.pop(context, note); // 🔥 رجّع قبل الحفظ

    await NoteService().createNots(note); // بعدين احفظ هاد كود الانسيرت للداتا بيز
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        title: const Text('Add Note'),
        backgroundColor: Colors.teal,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Description'),
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: () => _selectDate(context),
              child: Text(
                '📅 ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: saveNote,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}