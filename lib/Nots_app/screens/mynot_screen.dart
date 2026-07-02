import 'package:flutter/material.dart';
import 'package:note/Nots_app/screens/add_not_screen.dart';
import 'package:note/Nots_app/screens/Single_Note.dart';
import '../../Core/Utils/shared_prefernce.dart';
import '../models/note_models.dart';
import '../service/note_service.dart';
import 'Edit_Not_Screen.dart';

class MyNote extends StatefulWidget {
  const MyNote({super.key});

  @override
  State<MyNote> createState() => _MyNoteState();
}

class _MyNoteState extends State<MyNote> {
  final List<NoteModels> notes = [];
  Color starIconColor = Colors.grey;
  String? savedPass;
  final TextEditingController passwordController = TextEditingController();

  void loadPassword() {
    savedPass = AppSharedPreferences.getPassword();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadNotes();
    loadPassword();
  }

  Future<void> changeColor(NoteModels note) async {
    setState(() {
      note.isFavorite = !note.isFavorite;
    });
    await NoteService().updateNots(note);
  }

  Future<void> loadNotes() async {
    final data = await NoteService().getNots();
    final sortType = AppSharedPreferences.getSortType();

    if (!mounted) return;
    setState(() {
      notes.clear();
      notes.addAll(data);
      if (sortType == "name") {
        notes.sort((a, b) => a.title.compareTo(b.title));
      } else if (sortType == "date") {
        notes.sort((a, b) => (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));
      }
    });
  }

  Future<void> deleteNote(NoteModels note) async {
    await NoteService().deleteNots(note);
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
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
            icon: const Icon(Icons.search, size: 30),
          ),
        ],
        title: const Text('My Notes'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notes.length,
        separatorBuilder: (_, __) => Divider(color: theme.dividerColor),
        itemBuilder: (context, index) {
          final note = notes[index];

          return Column(
            children: [
              Text(
                note.date != null
                    ? "${note.date!.day}/${note.date!.month}/${note.date!.year}"
                    : "",
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textTheme.bodySmall?.color,
                ),
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
                  subtitle: Text(
                    note.isLocked == false ? note.description : "This Note is Locked",
                    style: TextStyle(
                      fontSize: 14, 
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7)
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('This Note is Locked')));
                    }
                  }),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: note.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => changeColor(note),
                  ),
                  IconButton(
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
                        } else {
                          final TextEditingController dialogPasswordController =
                              TextEditingController();

                          if (!context.mounted) return;
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: const Text("Enter Password"),
                                content: TextField(
                                  controller: dialogPasswordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Password',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.lock),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(dialogContext),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final currentSavedPass =
                                          AppSharedPreferences.getPassword();

                                      if ((currentSavedPass ?? '') ==
                                          dialogPasswordController.text) {
                                        Navigator.pop(dialogContext);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditNot(note: note),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Wrong password"),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text("Unlock"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Note'),
                            content:
                                const Text('Are you sure you want to delete this note?'),
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
                        }),
                  ),
                  if (note.isLocked)
                    IconButton(
                      icon: const Icon(
                        Icons.lock,
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: const Text('Enter Password'),
                            content: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if ((savedPass ?? '') == passwordController.text) {
                                    setState(() {
                                      note.isLocked = false;
                                    });

                                    Navigator.pop(dialogContext);
                                    passwordController.clear();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Wrong password ')));
                                  }
                                },
                                child: const Text('Unlock'),
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

class NoteSearchDelegate extends SearchDelegate {
  final List<NoteModels> notes;
  NoteSearchDelegate(this.notes);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = notes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildSearchResults(context, results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = notes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildSearchResults(context, suggestions);
  }

  Widget _buildSearchResults(BuildContext context, List<NoteModels> results) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final note = results[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(
            note.isLocked ? "This Note is Locked 🔒" : note.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: theme.textTheme.bodySmall?.color),
          ),
          leading: Icon(note.isLocked ? Icons.lock : Icons.note, color: Colors.teal),
          onTap: () {
            if (!note.isLocked) {
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
              _showPasswordDialog(context, note);
            }
          },
        );
      },
    );
  }

  void _showPasswordDialog(BuildContext context, NoteModels note) {
    final TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Enter Password"),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final currentSavedPass = AppSharedPreferences.getPassword();
              if ((currentSavedPass ?? '') == passwordController.text) {
                Navigator.pop(dialogContext); // Close dialog
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
                  const SnackBar(content: Text("Wrong password")),
                );
              }
            },
            child: const Text("Unlock"),
          ),
        ],
      ),
    );
  }
}
