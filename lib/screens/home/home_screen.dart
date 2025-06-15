import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senada/models/events/event_model.dart';
import 'package:senada/screens/detailPage/DetailPage.dart';
import 'package:senada/screens/menuPage/menuPage.dart';
import 'package:senada/services/events/event_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EventService eventService = EventService();
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final events = await eventService.getEvent();
      setState(() {
        _events = events;
      });
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2A55D),
        toolbarHeight: 60,
        title: const Text(
          'SENADA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        actions: <Widget> [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                FontAwesomeIcons.magnifyingGlass,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                  _buildCategoryItem('Tari\nTradisional', Icons.self_improvement, 'kt1', 'Pertunjukan Seni Tari'),
                  _buildCategoryItem('Musik\nDaerah', Icons.music_note, 'kt2', 'Pertunjukan Seni Musik'),
                  _buildCategoryItem('Teater', Icons.theater_comedy, 'kt3', 'Pertunjukan Teater'),
                  _buildCategoryItem('Festival\nBudaya', Icons.celebration, 'kt4', 'Pertunjukan Festival Budaya'),
                ],
              ),
            ),

            // Judul
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Tempat pertunjukan populer',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            // List Event Horizontal
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: _events.map((event) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _buildEventCard(
                        id: event.id,
                        title: event.title,
                        description: event.description,
                        imageUrl: event.thumbnail,
                      ),
                    ); 
                  }).toList(),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Jadwal Acara Terdekat',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: _events.map((event) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _buildEventCard(
                          id: event.id,
                          title: event.title,
                          description: event.description,
                          imageUrl: event.thumbnail,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, String categoryId, String titlePage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CulturalShowPage(categoryId: categoryId, titlePage: titlePage),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF6F8878),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required String id,
    required String title,
    required String description,
    required String imageUrl
    }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => DetailPage(eventId: id),
          ),
        );
      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 4),
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
              child: Image.network(
                imageUrl,
                height: 100,
                width: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 100,
                  width: 180,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 10),
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
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
