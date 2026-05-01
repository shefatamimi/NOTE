import 'package:flutter/material.dart';
import 'package:note/Nots_app/screens/addnotes.dart';
import 'package:note/Nots_app/screens/single note.dart';
import '../models/note_models.dart';
import '../service/note_service.dart';
import 'edit_notscreen.dart';

class MyNote extends StatefulWidget {
  const MyNote({super.key});

  @override
  State<MyNote> createState() => _MyNoteState();
}

class _MyNoteState extends State<MyNote> {
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
      notes.addAll(data);
    });
  }

  Future<void> deleteNote(NoteModels note) async {
    await NoteService().deleteNots(note);
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Addnotes(
                title: '',
                description: '',
                selectedDate: DateTime.now(),
              ),
            ),
          );

          if (result != null) {
             await loadNotes();
          }
        },
      ),

      appBar: AppBar(
        title: const Text('My Notes'),
        backgroundColor: Colors.teal,
      ),

      body: Card(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: notes.length,

          separatorBuilder: (_, __) =>
          const Divider(color: Colors.grey),

          itemBuilder: (context, index) {
            final note = notes[index];

            return Column(
              children: [
                Text(
                  note.date != null
                      ? "${note.date!.day}/${note.date!.month}/${note.date!.year}"
                      : "",
                  style: const TextStyle(fontSize: 12, color: Colors.grey,),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Text(note.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SingleNote(
                          title: note.title,
                          description: note.description,
                          selectedDate: note.date ?? DateTime.now(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,

                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final result = await Navigator.push(

                          context,
                          MaterialPageRoute(
                            builder: (_) => EditNot(note: note),
                          ),
                        );

                        if (result != null) {
                          loadNotes();
                        }
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteNote(note),
                    ),
                  ],
                ),


              ],

            );
          },
        ),
      ),
    );
  }
}