import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF2A3663),
        elevation: 20,
        unselectedItemColor: Colors.grey,
        onTap: widget.onItemTapped, // Menggunakan callback dari widget parent
        currentIndex: widget.selectedIndex,

        items: const [
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.house, size: 20), label: 'Beranda'),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.receipt, size: 20), label: 'History'),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.solidUser, size: 20), label: 'Akun'),
        ],
      ),
    );
  }
}
