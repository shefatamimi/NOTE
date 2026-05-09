import 'package:flutter/material.dart';
import 'package:note/Nots_app/screens/backup_screen.dart';
import 'package:note/Nots_app/screens/mynot_screen.dart';
import 'package:note/Nots_app/screens/privacy_policy_screen.dart';
import 'package:note/Nots_app/service/note_service.dart';
import '../../Core/Utils/shared_prefernce.dart';
import '../../widget/class_lock.dart';
import '../models/login_models.dart';
import '../models/note_models.dart';
import '../service/Login_Service.dart';
import 'about_app.dart';
import 'edit_profile_screen.dart';

class SettingScreen extends StatefulWidget {
  final LoginModels user;

  const SettingScreen({super.key, required this.user});



  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isDarkMode = false;
  final List<NoteModels> notes = [];

  Future<void> loadNotesAndApplySort() async {
    final data = await NoteService().getNots();
    final sortType = await AppSharedPreferences.getSortType();

    setState(() {
      notes.clear();
      notes.addAll(data);

      if (sortType == "name") {
        notes.sort((a, b) => a.title.compareTo(b.title));
      }
      else if (sortType == "date") {
        notes.sort((a, b) => a.date!.compareTo(b.date!));
      }
    });
  }

  Future<void> loadNotes() async {
    final data = await NoteService().getNots();
    setState(() {
      notes.clear();
      notes.addAll(data);
    });
  }

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> deleteNote(NoteModels note) async {
    await NoteService().deleteAllNotes();
    loadNotes();
  }


  Future<void> updateLogin() async {
    final updated = LoginModels(
      id: widget.user.id,
      email: widget.user.email,
      password: widget.user.password,
    );

    await LoginService().updateLogin(updated);

    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Settings',
            style: TextStyle(
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(height: 10,),
                Center(
                  child: Container(
                    height: 75,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),

                        ]
                    ),

                    child: Column(
                      children: [
                        SizedBox(height: 25,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Welcome', style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,

                            ),),
                            SizedBox(width: 8,),
                            Text('${widget.user.email.split('@')[0]}',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,

                              ),),
                            SizedBox(height: 20,),
                          ],
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Account', style: TextStyle(
                      fontSize: 15,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold
                  ),),
                ),
                SizedBox(height: 10,),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfile(user: widget.user,),
                          )
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ]
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.person, size: 30,),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text('Profile', style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,


                                  ),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text('View and Edit your profile',
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),),
                                ),

                              ]


                          ),
                          SizedBox(width: 137,),
                          Icon(Icons.arrow_forward_ios, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Appearence', style: TextStyle(
                      fontSize: 15,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold
                  ),),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Container(
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),

                        ]
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.dark_mode, size: 30,),

                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8),
                                child: Text('Dark Mode', style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8),
                                child: Text(
                                  'Enable dark mode', style: TextStyle(
                                  fontSize: 10,
                                ),),
                              ),

                            ]


                        ),
                        SizedBox(width: 130,),
                        Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            setState(() {
                              isDarkMode = value;
                            });
                          },
                        ),

                      ],
                    ),


                  ),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Container(
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),

                        ]
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.color_lens, size: 30,),

                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8),
                                child: Text('Theme Color', style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,


                                ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8),
                                child: Text(
                                  'Choose a theme color', style: TextStyle(
                                  fontSize: 10,
                                ),),
                              ),

                            ]


                        ),
                        SizedBox(width: 157,),
                        Icon(Icons.arrow_forward_ios, size: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Container(
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),

                        ]
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.text_fields, size: 30,),

                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8),
                                child: Text('Font Size', style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,


                                ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8),
                                child: Text(
                                  'Adjust the font size', style: TextStyle(
                                  fontSize: 10,
                                ),),
                              ),

                            ]


                        ),
                        SizedBox(width: 170,),
                        Icon(Icons.arrow_forward_ios, size: 20),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Notes', style: TextStyle(
                      fontSize: 15,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold
                  ),),
                ),
                SizedBox(height: 10,),
                Center(
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) {
                          return LockNotesBottomSheet(notesList: notes,);
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),

                          ]
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.lock, size: 30,),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text(
                                    'Locked Notes', style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text(
                                    'Manage your locked notes', style: TextStyle(
                                    fontSize: 10,
                                  ),),
                                ),
                              ]
                          ),
                          SizedBox(width: 135,),
                          Icon(Icons.arrow_forward_ios, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Center(
                  child: InkWell(
                    onTap: () {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: Text('Sort Notes'),
                          content: Text('Select a sorting option:'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await AppSharedPreferences.setSortType("date");

                                Navigator.pop(context,true);
                              },
                              child: Text('sort by date'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await AppSharedPreferences.setSortType("name");

                                Navigator.pop(context,true);
                              },
                              child: Text('sort A-z'),
                            ),
                          ],
                        );
                      },

                      );
                    },

                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),

                          ]
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.filter_list, size: 30,),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text('Notes Sorting', style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text('Newest first', style: TextStyle(
                                    fontSize: 10,
                                  ),),
                                ),
                              ]
                          ),
                          SizedBox(width: 160,),
                          Icon(Icons.arrow_forward_ios, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Data & Storage', style: TextStyle(
                      fontSize: 15,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold
                  ),),
                ),
                SizedBox(height: 10,),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BackupScreen(),
                        ),
                      );
                    },

                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),

                          ]
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.cloud_circle, size: 30,),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text(
                                    'Backup & Restore', style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text(
                                    'Backup your notes', style: TextStyle(
                                    fontSize: 10,
                                  ),),
                                ),
                              ]
                          ),
                          SizedBox(width: 130,),
                          Icon(Icons.arrow_forward_ios, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Center(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Delete All Notes'),
                            content: Text(
                                'Are you sure you want to delete all notes?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await NoteService().deleteAllNotes(

                                  );
                                  Navigator.pop(context);
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },

                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),

                          ]
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.delete, size: 30,),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text(
                                    'Delete All Notes', style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text('Permanently delete all notes',
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),),
                                ),
                              ]
                          ),
                          SizedBox(width: 120,),
                          Icon(Icons.arrow_forward_ios, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,), SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Other', style: TextStyle(
                      fontSize: 15,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold
                  ),),
                ),
                SizedBox(height: 10,),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutApp(),
                        ),
                      );
                    },


                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),

                          ]
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.info_outline, size: 30,),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text('About App', style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text('Learn more about the app',
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),),
                                ),
                              ]
                          ),
                          SizedBox(width: 132,),
                          Icon(Icons.arrow_forward_ios, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrivacyPolicy(),
                          )
                      );
                    },

                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),

                          ]
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.privacy_tip, size: 30,),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text(
                                    'Privacy Policy', style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: Text(
                                    'Read our privacy policy', style: TextStyle(
                                    fontSize: 10,
                                  ),),
                                ),
                              ]
                          ),
                          SizedBox(width: 143,),
                          Icon(Icons.arrow_forward_ios, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),


              ]


          ),
        )

    );
  }

}