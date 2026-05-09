import 'package:flutter/material.dart';
import '../Nots_app/models/note_models.dart';

class LockNotesBottomSheet extends StatefulWidget {
  final List<NoteModels> notesList;

  const LockNotesBottomSheet({
    super.key,
    required this.notesList,
  });

  @override
  State<LockNotesBottomSheet> createState() => _LockNotesBottomSheetState();
}

class _LockNotesBottomSheetState extends State<LockNotesBottomSheet> {
  late List<bool> selected;

  @override
  void initState() {
    super.initState();
    selected = List.generate(widget.notesList.length, (index) => false);
  }

  void toggleAll(bool value) {
    setState(() {
      selected = List.generate(selected.length, (index) => value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Text(
            "🔐 Select Notes to Lock",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => toggleAll(true),
                child: Text("Select All"),
              ),
              TextButton(
                onPressed: () => toggleAll(false),
                child: Text("Unselect All"),
              ),
            ],
          ),

          Divider(),

          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.notesList.length,
              itemBuilder: (context, index) {
                final note = widget.notesList[index];

                return CheckboxListTile(
                  title: Text(note.title),
                  value: selected[index],
                  onChanged: (value) {
                    setState(() {
                      selected[index] = value!;
                    });
                  },
                );
              },
            ),
          ),

          SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                List<NoteModels> lockedNotes = [];

                for (int i = 0; i < widget.notesList.length; i++) {
                  if (selected[i]) {
                    lockedNotes.add(
                      widget.notesList[i].copyWith(isLocked: true),
                    );
                  }
                }

                Navigator.pop(context, lockedNotes);
              },
              child: Text("🔒 Lock Selected Notes"),
            ),
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}