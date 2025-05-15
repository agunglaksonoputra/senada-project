import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:senada/Screens/reservation/reservation.dart';
import 'package:senada/models/events/event_model.dart';
import 'package:senada/models/ticket/ticket_model.dart';
import 'package:senada/services/events/event_service.dart';
import 'package:senada/services/tickets/ticket_service.dart';

class DetailPage extends StatefulWidget {
  final int eventId;

  const DetailPage({Key? key, required this.eventId}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final EventService eventService = EventService();
  final TicketService ticketService = TicketService();
  Event? _event;
  List<Ticket> _tickets = [];
  Map<DateTime, List<Ticket>> _ticketsByDate = {};
  DateTime? _selectedDate;
  Ticket? _selectedTicket;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEventAndTickets();
  }

  Future<void> _fetchEventAndTickets() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch event details
      final event = await eventService.getById(widget.eventId);

      // Fetch tickets for this event
      final tickets = await ticketService.getTicketEvent(widget.eventId);

      // Group tickets by date
      final ticketsByDate = <DateTime, List<Ticket>>{};
      for (var ticket in tickets) {
        final date = DateTime(
          ticket.sessionStartDate.year,
          ticket.sessionStartDate.month,
          ticket.sessionStartDate.day,
        );

        if (!ticketsByDate.containsKey(date)) {
          ticketsByDate[date] = [];
        }
        ticketsByDate[date]!.add(ticket);
      }

      setState(() {
        _event = event;
        _tickets = tickets;
        _ticketsByDate = ticketsByDate;

        // Select the first date by default if available
        if (ticketsByDate.isNotEmpty) {
          _selectedDate = ticketsByDate.keys.first;
        }

        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_event == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: const Color(0xFFB2A55D),
        ),
        body: const Center(child: Text('Event tidak ditemukan')),
      );
    }

    final event = _event!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFFB2A55D),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageSection(event.thumbnail),
            TitleSection(
              name: event.title,
              rating: 8.5,
              reviewCount: 100,
            ),
            TextSection(deskripsi: event.description ?? ''),
            InformasiSection(
              name: event.title,
              lokasi: event.location ?? '',
              telepon: event.phoneNumber ?? '',
            ),
            if (_ticketsByDate.isNotEmpty) _buildDateSelectionSection(),
            if (_selectedDate != null) _buildTicketSelectionSection(event),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 15, bottom: 10),
          child: Text(
            'Jadwal pertunjukan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: _ticketsByDate.keys.length,
            itemBuilder: (context, index) {
              final date = _ticketsByDate.keys.elementAt(index);
              final isSelected = _selectedDate == date;
              final dateFormat = DateFormat('d MMM');
              final dayFormat = DateFormat('E');

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                    _selectedTicket = null; // Reset selected ticket
                  });
                },
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3C5932) : const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayFormat.format(date)[0].toUpperCase() +
                            dayFormat.format(date).substring(1, 3),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        dateFormat.format(date),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
    );
  }

  Widget _buildTicketSelectionSection(Event event) {
    final ticketsForSelectedDate = _ticketsByDate[_selectedDate] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 15, bottom: 10),
          child: Text(
            'Tiket pertunjukan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: ticketsForSelectedDate.map((ticket) {
              final isAvailable = ticket.isActive && !ticket.isSold;
              final isSelected = _selectedTicket == ticket;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? const Color(0xFF3C5932) : Colors.grey.shade300,
                    width: isSelected ? 2 : 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: isAvailable
                      ? Colors.white
                      : const Color(0xFFF5F5F5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ticket.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${ticket.sessionStartTime} - ${ticket.sessionEndTime}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: isAvailable
                          ? ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ReservationPage(eventName: event.title)
                          ));
                          setState(() {
                            _selectedTicket = ticket;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: isSelected
                              ? const Color(0xFF3C5932)
                              : const Color(0xFF3C5932),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(70, 36),
                        ),
                        child: const Text('Pilih'),
                      )
                          : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Tidak tersedia',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

}

// Keep original widget components
class ImageSection extends StatelessWidget {
  final String image;
  const ImageSection(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      image,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        height: 250,
        width: double.infinity,
        color: Colors.grey[300],
        child: Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final String name;
  final double rating;
  final int reviewCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFb2a55d),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '$rating/10',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$reviewCount ulasan',
                style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextSection extends StatelessWidget {
  final String deskripsi;
  const TextSection({super.key, required this.deskripsi});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(deskripsi, textAlign: TextAlign.justify, style: const TextStyle(fontSize: 14)),
    );
  }
}

class InformasiSection extends StatelessWidget {
  final String name;
  final String lokasi;
  final String telepon;

  const InformasiSection({
    super.key,
    required this.name,
    required this.lokasi,
    required this.telepon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFF3C5932), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(lokasi, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.phone, color: Color(0xFF3C5932), size: 20),
              const SizedBox(width: 10),
              Text(telepon, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}