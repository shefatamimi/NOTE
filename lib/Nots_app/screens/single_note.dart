import 'package:flutter/material.dart';

class SingleNote extends StatefulWidget {
  const SingleNote({
    super.key,
    required this.title,
    required this.description,
    required this.selectedDate,
  });

  @override
  State<SingleNote> createState() => _SingleNoteState();
  final String title;
  final String description;
  final DateTime selectedDate;
}

class _SingleNoteState extends State<SingleNote> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('My Notes'),
          centerTitle: true,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                    style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ]),
        ));
  }
}
