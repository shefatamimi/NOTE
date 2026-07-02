import 'package:flutter/material.dart';
import '../Core/Utils/shared_prefernce.dart';
import '../Nots_app/models/note_models.dart';
import '../Nots_app/service/note_service.dart';

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
    selected = List.generate(
      widget.notesList.length, 
      (index) => widget.notesList[index].isLocked
    );
  }

  void toggleAll(bool value) {
    setState(() {
      selected = List.generate(selected.length, (index) => value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "🔐 Manage Locked Notes",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => toggleAll(true),
                child: const Text("Select All"),
              ),
              TextButton(
                onPressed: () => toggleAll(false),
                child: const Text("Unselect All"),
              ),
            ],
          ),
          const Divider(),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.notesList.length,
              itemBuilder: (context, index) {
                final note = widget.notesList[index];
                return CheckboxListTile(
                  activeColor: Colors.teal,
                  title: Text(note.title),
                  subtitle: Text(
                    note.isLocked ? "Currently Locked" : "Unlocked",
                    style: TextStyle(fontSize: 12, color: theme.textTheme.bodySmall?.color),
                  ),
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
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                TextEditingController passwordController = TextEditingController();
                
                await showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text("🔐 Confirm with Password"),
                      content: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: "Enter password to save changes",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String password = passwordController.text;
                            final savedPass = AppSharedPreferences.getPassword();

                            // إذا كانت هناك كلمة مرور محفوظة، نتحقق منها أولاً
                            if (savedPass != null && savedPass.isNotEmpty) {
                              if (password != savedPass) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Wrong password!")),
                                );
                                return;
                              }
                            } else {
                              // إذا لم يكن هناك باسورد، نقوم بحفظ المدخل كباسورد جديد
                              await AppSharedPreferences.savePassword(password);
                            }

                            // تحديث حالة كل الملاحظات بناءً على الاختيار الجديد
                            for (int i = 0; i < widget.notesList.length; i++) {
                              final updatedNote = widget.notesList[i].copyWith(
                                isLocked: selected[i]
                              );
                              await NoteService().updateNots(updatedNote);
                            }

                            if (context.mounted) {
                              Navigator.pop(dialogContext); // إغلاق الديالوج
                              Navigator.pop(context, true); // إغلاق القائمة السفلية
                            }
                          },
                          child: const Text("Save Changes"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("🔒 Apply Changes"),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
