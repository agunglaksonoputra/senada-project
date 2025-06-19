import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senada/models/events/event_model.dart';
import 'package:senada/screens/DetailPage/DetailPage.dart';
import 'package:senada/services/events/event_service.dart';

class CulturalShowPage extends StatefulWidget {
  final String categoryId;
  final String titlePage;

  const CulturalShowPage({
    Key? key,
    required this.categoryId,
    required this.titlePage,
  }) : super(key: key);

  @override
  State<CulturalShowPage> createState() => _CulturalShowPageState();
}

class _CulturalShowPageState extends State<CulturalShowPage> {
  final EventService eventService = EventService();

  List<Event> allEvents = [];
  List<Event> filteredEvents = [];
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
    "BALI",
    "LAMPUNG"
  ];

  String selectedDaerah = "SEMUA";

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    setState(() => isLoading = true);
    try {
      final data = await eventService.getEventByCategory(widget.categoryId);
      setState(() {
        allEvents = data;
        filteredEvents = List.from(allEvents);
      });
    } catch (e) {
      print('Error fetching events: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void filterEventsByDaerah() {
    setState(() {
      if (selectedDaerah == "SEMUA") {
        filteredEvents = List.from(allEvents);
      } else {
        filteredEvents = allEvents.where((event) {
          final location = event.location?.toLowerCase() ?? '';
          return location.contains(selectedDaerah.toLowerCase());
        }).toList();
      }
    });
  }

  void showDaerahDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Container(
        height: 500,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDialogHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: daerahList.length,
                separatorBuilder: (_, __) => const Divider(height: 0.5),
                itemBuilder: (context, index) {
                  final daerah = daerahList[index];
                  final isSelected = daerah == selectedDaerah;

                  return InkWell(
                    onTap: () {
                      setState(() => selectedDaerah = daerah);
                      Navigator.pop(context);
                      filterEventsByDaerah();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            daerah,
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF5F8B4C) : null,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          if (isSelected)
                            const FaIcon(FontAwesomeIcons.check, color: Color(0xFF5F8B4C)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFFb2a55d),
        toolbarHeight: 60,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.angleLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: showDaerahDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.place, color: Color(0xFF5F8B4C), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      selectedDaerah,
                      style: const TextStyle(
                        color: Color(0xFF5F8B4C),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.titlePage,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredEvents.isEmpty
                  ? const Center(child: Text('Tidak ada event.'))
                  : ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) =>
                    _buildEventCard(filteredEvents[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Pilih Daerah',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        InkWell(
          onTap: () => Navigator.pop(context),
          child: const FaIcon(FontAwesomeIcons.xmark),
        ),
      ],
    );
  }

  Widget _buildEventCard(Event event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => DetailPage(eventId: event.id), // Kirim eventId ke DetailPage
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
              child: Image.network(
                event.thumbnail,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
