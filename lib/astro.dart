import 'package:flutter/material.dart';

class AstroPage extends StatefulWidget {
  const AstroPage({super.key});

  @override
  State<AstroPage> createState() => _AstroPageState();
}

class _AstroPageState extends State<AstroPage> {
  int _selectedIndex = 0;
  static const List<Widget> _pageOptions = <Widget>[
    Text(
      'Space Weather',
    ),
    Text(
      'Mars Rover Photos',
    ),
    Text(
      'NASA images',
    )
  ];

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const String iconPath = 'assets/icons/';
    return Scaffold(
      body: _pageOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.wb_cloudy), label: "Space weather"),
          BottomNavigationBarItem(
              icon: Image.asset(
                '${iconPath}mars.png',
                width: 25,
              ),
              label: "Mars"),
          BottomNavigationBarItem(
              icon: Image.asset(
                '${iconPath}nasa.png',
                width: 25,
              ),
              label: "NASA image"),
        ],
        onTap: changeTab,
      ),
    );
  }
}