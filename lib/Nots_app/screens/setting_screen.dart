import 'package:flutter/material.dart';
import 'package:note/Nots_app/screens/backup_screen.dart';
import 'package:note/Nots_app/service/note_service.dart';
import 'package:provider/provider.dart';
import '../../Core/Providers/theme_provider.dart';
import '../../Core/Utils/shared_prefernce.dart';
import '../../widget/class_lock.dart';
import '../models/login_models.dart';
import '../models/note_models.dart';
import 'about_app.dart';
import 'edit_profile_screen.dart';
import 'privacy_policy_screen.dart';

class SettingScreen extends StatefulWidget {
  final LoginModels user;

  const SettingScreen({super.key, required this.user});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final List<NoteModels> notes = [];

  Future<void> loadNotes() async {
    final data = await NoteService().getNots();
    if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Welcome Header
            Center(
              child: Container(
                height: 80,
                width: 350,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        widget.user.email.split('@')[0],
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            _buildSectionTitle('Account'),
            _buildSettingTile(
              icon: Icons.person,
              title: 'Profile',
              subtitle: 'View and Edit your profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfile(user: widget.user)),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Appearance'),
            // Dark Mode Custom Tile
            Center(
              child: Container(
                height: 60,
                width: 350,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      const Icon(Icons.dark_mode, size: 28, color: Colors.teal),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Dark Mode', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            Text('Enable dark mode', style: TextStyle(fontSize: 11, color: theme.textTheme.bodySmall?.color)),
                          ],
                        ),
                      ),
                      Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme(value);
                        },
                        activeColor: Colors.teal,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildSettingTile(
              icon: Icons.color_lens,
              title: 'Theme Color',
              subtitle: 'Choose a theme color',
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.text_fields,
              title: 'Font Size',
              subtitle: 'Adjust the font size',
              onTap: () {},
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Notes Management'),
            _buildSettingTile(
              icon: Icons.lock,
              title: 'Locked Notes',
              subtitle: 'Manage your locked notes',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => LockNotesBottomSheet(notesList: notes),
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.filter_list,
              title: 'Notes Sorting',
              subtitle: 'Change how notes appear',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Sort Notes'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await AppSharedPreferences.setSortType("date");
                          if (!mounted) return;
                          Navigator.pop(context);
                          loadNotes();
                        },
                        child: const Text('Sort by Date'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await AppSharedPreferences.setSortType("name");
                          if (!mounted) return;
                          Navigator.pop(context);
                          loadNotes();
                        },
                        child: const Text('Sort A-Z'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Data & Privacy'),
            _buildSettingTile(
              icon: Icons.cloud_circle,
              title: 'Backup & Restore',
              subtitle: 'Backup your notes',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BackupScreen()));
              },
            ),
            _buildSettingTile(
              icon: Icons.delete_forever,
              title: 'Delete All Notes',
              subtitle: 'Permanently delete all notes',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete All'),
                    content: const Text('Are you sure you want to delete everything?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () async {
                          await NoteService().deleteAllNotes();
                          if (!mounted) return;
                          Navigator.pop(context);
                          loadNotes();
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('About'),
            _buildSettingTile(
              icon: Icons.info_outline,
              title: 'About App',
              subtitle: 'Learn more about the app',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutApp()));
              },
            ),
            _buildSettingTile(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicy()));
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.teal, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 60,
            width: 350,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Icon(icon, size: 28, color: Colors.teal),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(subtitle, style: TextStyle(fontSize: 11, color: theme.textTheme.bodySmall?.color)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
