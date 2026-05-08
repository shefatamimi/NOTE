import 'package:flutter/material.dart';
import 'package:note/Nots_app/screens/fav_note.dart';
import '../models/login_models.dart';
import 'mynot_screen.dart';
import 'setting_screen.dart';
class HomeScreen extends StatefulWidget {
  final LoginModels user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentindex=0;
  late final screens=[

    MyNote(),
    FavNote(),
    SettingScreen(user: widget.user),





  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentindex,
        onTap: (index) => setState(() => currentindex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings),
            label: 'Settings',
          )
        ],
      ),





    );
  }
}