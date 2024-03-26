import 'package:app_movie/firebase_options.dart';
import 'package:app_movie/screen/home_screen.dart';
import 'package:app_movie/screen/login_screen.dart';
import 'package:app_movie/screen/user_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 19),
          backgroundColor: Colors.black,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Account(),
    Center(
      child: Text(
        'Index 2: School',
        style: optionStyle,
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            width: mq.width,
            height: mq.height,
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              margin: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20.0), bottom: Radius.circular(20.0)),
                child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: "Home"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline), label: "User"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.favorite_border), label: "Favorite"),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.red,
                  unselectedItemColor: Colors.white,
                  onTap: _onItemTapped,
                  backgroundColor: const Color.fromARGB(255, 25, 25, 25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
