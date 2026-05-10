import 'package:flutter/material.dart';
import 'package:note/Nots_app/screens/add_not_screen.dart';
import 'package:note/Nots_app/screens/Single_Note.dart';
import '../../Core/Utils/shared_prefernce.dart';
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
  String? savedPass;
  final TextEditingController passwordController = TextEditingController();


  Future<void> loadPassword() async {
    savedPass = await AppSharedPreferences.getPassword();
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    loadNotes();
    loadPassword();

  }
  Future<void>Changecolor(NoteModels note) async {
    setState(() {
      note.isFavorite = !note.isFavorite;

    });
    await NoteService().updateNots(note);
  }


  Future<void> loadNotes() async {
    final data = await NoteService().getNots();
    final sortType = await AppSharedPreferences.getSortType();

    setState(() {
      notes.clear();
      notes.addAll(data);
      if (sortType == "name") {
        notes.sort((a, b) => a.title.compareTo(b.title));
      }
      else if (sortType == "date") {
        notes.sort((a, b) => b.date!.compareTo(a.date!));
      }
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
            onPressed: ()  async{
              final pass = await AppSharedPreferences.getPassword();
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
                    if (note.isLocked ==false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SingleNote(
                                title: note.title,
                                description: note.description,
                                selectedDate: note.date ?? DateTime.now(),
                              ),
                        ),
                      );
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('This Note is Locked'))
                      );
                    }
                  }
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  IconButton(
                    icon: Icon(Icons.favorite,color: note.isFavorite?Colors.red:Colors.grey,),
                    onPressed: () => Changecolor(note),

                  ),IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        if (note.isLocked == false) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditNot(note: note),
                            ),
                          );

                          if (result != null) {
                            loadNotes();
                          }
                        }
                        else {
                          List<NoteModels> lockedNotes = [];

                          TextEditingController passwordController =
                          TextEditingController();


                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("Enter Password"),
                                content: TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.lock),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async{
                                      final savedPass = await AppSharedPreferences.getPassword();

                                      if ((savedPass ?? '') == passwordController.text) {
                                        Navigator.pop(context);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditNot(note:note

                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Wrong password"),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text("Unlock"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Note'),
                            content: const Text('Are you sure you want to delete this note?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteNote(note);
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );

                        }
                        ),

                  ),
                  if (note.isLocked)
                    IconButton(
                      icon: Icon(Icons.lock,
                      ),
                      onPressed: () =>
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                              title: Text('Enter Password'),
                              content: TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if ((savedPass ?? '') == passwordController.text){
                                      setState(() {
                                        note.isLocked=false;
                                      });

                                      Navigator.pop(context);
                                      passwordController.clear();

                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content:Text('Wrong password '))

                                      );
                                    };



                                  },
                                  child: Text('Unlock'),
                                ),
                              ],
                            );
                          },
                          ),
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



  NoteSearchDelegate(this.notes,);
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
          onTap: () {
            if (note.isLocked == false) {
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
            } else {
              List<NoteModels> lockedNotes = [];

              TextEditingController passwordController =
              TextEditingController();


              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text("Enter Password"),
                    content: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async{
                          final savedPass = await AppSharedPreferences.getPassword();

                          if ((savedPass ?? '') == passwordController.text) {
                            Navigator.pop(context);

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
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Wrong password"),
                              ),
                            );
                          }
                        },
                        child: Text("Unlock"),
                      ),
                    ],
                  );
                },
              );
            }
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