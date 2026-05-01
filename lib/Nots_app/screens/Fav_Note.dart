import 'package:flutter/material.dart';
import 'package:note/Nots_app/screens/Single_Note.dart';

import '../models/note_models.dart';
import '../service/note_service.dart';
class FavNote extends StatefulWidget {
  const FavNote({super.key});

  @override
  State<FavNote> createState() => _FavNoteState();
}

class _FavNoteState extends State<FavNote> {
  final List<NoteModels> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final data = await NoteService().getNots();

    setState(() {
      notes.clear();
      notes.addAll(
        data.where((note) => note.isFavorite).toList(),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favourite Notes'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notes.length,
        separatorBuilder: (_, __) => const Divider(color: Colors.grey),
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(note.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        SingleNote(
                          title: note.title,
                          description: note.description,
                          selectedDate: note.date ?? DateTime.now(),
                        )

                ),
              );
            },
          );
        },
      ),
    );
  }
}