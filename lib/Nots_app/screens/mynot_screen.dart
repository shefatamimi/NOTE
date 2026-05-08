import 'package:flutter/material.dart';
import 'package:note/Nots_app/screens/add_not_screen.dart';
import 'package:note/Nots_app/screens/Single_Note.dart';
import '../models/note_models.dart';
import '../service/note_service.dart';
import 'fav_note_screen.dart';
import 'Edit_Not_Screen.dart';

class MyNote extends StatefulWidget {
  const MyNote({super.key});

  @override
  State<MyNote> createState() => _MyNoteState();
}

class _MyNoteState extends State<MyNote> {
  final List<NoteModels> notes = [];
  late var star_icon_color=Colors.grey;




  @override
  void initState() {
    super.initState();
    loadNotes();
  }
  Future<void>Changecolor(NoteModels note) async {
    setState(() {
      note.isFavorite = !note.isFavorite;
    });
    await NoteService().updateNots(note);
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
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: NoteSearchDelegate(notes),
              );
            },

            icon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: const Icon(Icons.search,size: 35,),
            ),
          )

        ],
        title: const Text('My Notes'),
        backgroundColor: Colors.teal,

      ),

      body:
      ListView.separated(
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
                    icon: Icon(Icons.favorite,color: note.isFavorite?Colors.red:Colors.grey,),
                    onPressed: () => Changecolor(note),

                  ),
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
    );
  }
}

class NoteSearchDelegate extends SearchDelegate<NoteModels?> {
  final List<NoteModels> notes;

  NoteSearchDelegate(this.notes);
// clear button
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }
// arrow back button
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }
// result of search
  @override
  Widget buildResults(BuildContext context) {
    // not is  the element in the list notes(for loop for each element in the list)
    // conditions for search results(if not contain the query)
    // if conditon is true=> go to bulider list
    final results = notes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final note = results[index];

        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.description),
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
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = notes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final note = suggestions[index];

        return ListTile(
          title: Text(note.title),
          onTap: () {
            query = note.title;
            showResults(context);
          },
        );
      },
    );
  }
}