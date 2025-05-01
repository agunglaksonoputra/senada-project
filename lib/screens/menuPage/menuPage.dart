import 'package:flutter/material.dart';
import 'package:senada/models/events/event_model.dart';
import 'package:senada/services/events/event_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CulturalShowPage extends StatefulWidget {
  final int categoryId;
  final String titlePage;

  const CulturalShowPage({Key? key, required this.categoryId, required this.titlePage}) : super(key: key);

  @override
  _CulturalShowPageState createState() => _CulturalShowPageState();
}

class _CulturalShowPageState extends State<CulturalShowPage> {
  final EventService eventService = EventService(Supabase.instance.client);

  List<Event> allEvents = [];     // Semua event dari Supabase
  List<Event> filteredEvents = []; // Event yang difilter berdasarkan daerah
  bool isLoading = true;

  final List<String> daerahList = [
    "SEMUA",
    "JAWA BARAT",
    "JAKARTA",
    "SUMATRA BARAT",
    "SUMATRA SELATAN",
    "JAWA TENGAH",
    "YOGYAKARTA",
    "BANTEN",
    "BALI"
  ];

  String selectedDaerah = "SEMUA"; // Default

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 🔥 Fetch berdasarkan CategoryId
      final data = await eventService.getEventsByCategoryId(widget.categoryId);

      setState(() {
        allEvents = data;
        filteredEvents = List.from(allEvents); // Default semua tampil
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterEventsByDaerah() {
    setState(() {
      if (selectedDaerah == "SEMUA") {
        filteredEvents = List.from(allEvents);
      } else {
        final daerahLower = selectedDaerah.toLowerCase();
        filteredEvents = allEvents.where((event) {
          final location = event.location?.toLowerCase() ?? '';
          return location.contains(daerahLower);
        }).toList();
      }
    });
  }

  void showDaerahDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: SizedBox(
            height: 400,
            child: Column(
              children: [
                ListTile(
                  title: Text('Pilih Daerah', style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: daerahList.length,
                    itemBuilder: (context, index) {
                      final daerah = daerahList[index];
                      return ListTile(
                        title: Text(
                          daerah,
                          style: TextStyle(
                            color: daerah == selectedDaerah ? Color(0xFF5F8B4C) : null,
                            fontWeight: daerah == selectedDaerah ? FontWeight.bold : null,
                          ),
                        ),
                        trailing: daerah == selectedDaerah
                            ? Icon(Icons.check, color: Color(0xFF5F8B4C))
                            : null,
                        onTap: () {
                          setState(() {
                            selectedDaerah = daerah;
                          });
                          Navigator.pop(context);
                          filterEventsByDaerah(); // 🔥 Langsung filter event
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFFb2a55d),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: showDaerahDialog,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.place, color: Color(0xFF5F8B4C), size: 16),
                    SizedBox(width: 4),
                    Text(
                      selectedDaerah,
                      style: TextStyle(color: Color(0xFF5F8B4C), fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.titlePage,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : filteredEvents.isEmpty
                        ? Center(child: Text('Tidak ada event.'))
                        : ListView.builder(
                            itemCount: filteredEvents.length,
                            itemBuilder: (context, index) {
                              final event = filteredEvents[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/DetailPage'); // Sesuaikan dengan detail
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          event.thumbnail,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 100,
                                              height: 100,
                                              color: Colors.grey,
                                              child: Icon(Icons.broken_image, color: Colors.white),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event.title,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              event.description ?? '',
                                              style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
