import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Profile.dart';
import 'generalcomponents/AppBar.dart';

const double coverHeight = 200;
const double coverWidth = 190;
const double boxHeight = 250;
const double boxWidth = 190;
const int numberOfCharactersPerLine = 30;
const int totalNumberOfCharacters = 100;
const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title, this.userData});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  dynamic userData;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  var titlesAndId = [];
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget bodyFunction(String names, int index) {
    switch (index) {
      case 3:
        return Profile(
          userData: widget.userData,
          frozen: false,
          lookAt: '',
        );
        break;
      case 2:
        return HomePage(
          key: PageStorageKey('Best Sellers'),
          title: widget.title,
          names: names,
          order: {
            "relevance": "desc",
          },
          userData: widget.userData,
        );
        break;
      case 1:
        return HomePage(
          key: PageStorageKey('Reviews'),
          title: widget.title,
          names: names,
          order: {
            "followedCount": "desc",
          },
          userData: widget.userData,
        );
        break;
      default:
        return HomePage(
          key: PageStorageKey('Top Manga'),
          title: widget.title,
          names: names,
          order: {
            "rating": "desc",
          },
          userData: widget.userData,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    String names = "Top Manga";
    if (_selectedIndex == 1) {
      names = 'Review';
    }
    if (_selectedIndex == 2) {
      names = "Best Sellers";
    }

    return Scaffold(
        appBar: getAppBar(context),
        body: bodyFunction(names, _selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: 'Top Manga',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories),
              label: 'Reviews',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Best Sellers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.man_sharp),
              label: 'Account',
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orange[800],
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ));
  }
}
