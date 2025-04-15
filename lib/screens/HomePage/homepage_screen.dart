import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2A55D),
        toolbarHeight: 100,
        title: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryItem('Tari\nTradisional', Icons.self_improvement),
                  _buildCategoryItem('Musik\nDaerah', Icons.music_note),
                  _buildCategoryItem('Teater', Icons.theater_comedy),
                  _buildCategoryItem('Festival\nBudaya', Icons.celebration),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                'Tempat pertunjukan populer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    // Card
                    _buildEventCard(
                        'Tari Kecak & Api Uluwatu',
                        'Pertunjukan seni tradisional Bali yang menggabungkan tarian, drama, dan unsur spiritual. Tarian ini dikenal karena kekuatan vokal para penarinya yang duduk melingkar dan melantunkan "cak, cak, cak" secara berirama tanpa iringan alat musik.',
                        'assets/images/tari_kecak.jpg'
                    ),
                    SizedBox(width: 10),
                    _buildEventCard(
                        'Tari Kecak & Api Uluwatu',
                        'Pertunjukan seni tradisional Bali yang menggabungkan tarian, drama, dan unsur spiritual. Tarian ini dikenal karena kekuatan vokal para penarinya yang duduk melingkar dan melantunkan "cak, cak, cak" secara berirama tanpa iringan alat musik.',
                        'assets/images/tari_kecak.jpg'
                    ),
                    SizedBox(width: 10),
                    _buildEventCard(
                        'Tari Kecak & Api Uluwatu',
                        'Pertunjukan seni tradisional Bali yang menggabungkan tarian, drama, dan unsur spiritual. Tarian ini dikenal karena kekuatan vokal para penarinya yang duduk melingkar dan melantunkan "cak, cak, cak" secara berirama tanpa iringan alat musik.',
                        'assets/images/tari_kecak.jpg'
                    ),
                    SizedBox(width: 10),
                    _buildEventCard(
                        'Tari Kecak & Api Uluwatu',
                        'Pertunjukan seni tradisional Bali yang menggabungkan tarian, drama, dan unsur spiritual. Tarian ini dikenal karena kekuatan vokal para penarinya yang duduk melingkar dan melantunkan "cak, cak, cak" secara berirama tanpa iringan alat musik.',
                        'assets/images/tari_kecak.jpg'
                    ),
                    SizedBox(width: 10),
                    _buildEventCard(
                        'Tari Kecak & Api Uluwatu',
                        'Pertunjukan seni tradisional Bali yang menggabungkan tarian, drama, dan unsur spiritual. Tarian ini dikenal karena kekuatan vokal para penarinya yang duduk melingkar dan melantunkan "cak, cak, cak" secara berirama tanpa iringan alat musik.',
                        'assets/images/tari_kecak.jpg'
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, -4), // Shadow ke atas
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF2A3663),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Komunitas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Favorit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6F8878),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size:30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(String title, String description, String ImagePath) {
    return InkWell(
      onTap: () {
        // Navigasi ke halaman lain saat card diklik

      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,  // Latar belakang putih
          borderRadius: BorderRadius.circular(8),  // Sudut melengkung
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Warna shadow dengan opacity
              blurRadius: 5, // Jarak blur shadow
              offset: Offset(0, 4), // Posisi shadow (horizontal, vertical)
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.asset(
                ImagePath,
                height: 100,
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

