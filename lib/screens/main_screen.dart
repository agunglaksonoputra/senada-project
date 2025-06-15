import 'package:flutter/material.dart';
import 'package:senada/screens/history/history.dart';
import 'package:senada/screens/home/home_screen.dart';
import 'package:senada/screens/account/account_screen.dart';
import 'package:senada/screens/community/community_screen.dart';
import 'package:senada/widgets/bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> ScreenList = const [
    HomePage(),
    // CommunityPage(),
    HistoryPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ScreenList[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavBar(
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
      ),
    );
  }
}