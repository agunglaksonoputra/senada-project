import 'package:flutter/material.dart';
import 'package:senada/Screens/reservation/reservation.dart';
import 'package:senada/models/events/event_model.dart';

import 'package:senada/services/events/event_service.dart';

// void main() => runApp(const MaterialApp(home: DetailPage(eventId: null,)));

class DetailPage extends StatefulWidget {
  final int eventId; // EventId parameter

  const DetailPage({Key? key, required this.eventId}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final EventService eventService = EventService();
  Event? _event;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final events = await eventService.getById(
          widget.eventId); // Pastikan EventService ada dan benar
      setState(() {
        _event = events;
      });
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_event == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final event = _event!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFFB2A55D),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageSection(event.thumbnail ?? ''),
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
            // JadwalSection(
            //   listHari: event.schedule?.days ?? [],
            //   listTanggal: event.schedule?.dates ?? [],
            //   listJam: event.schedule?.times ?? [],
            //   judulHari: 'Pilih Hari',
            //   judulJam: 'Pilih Jam',
            // ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const ReservationPage(
                  eventName: "Pertunjukan Tari Kecak & Api di Uluwatu",
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A3663),
            foregroundColor: Colors.white,
          ),
          child: const Text('BELI TIKET SEKARANG'),
        ),
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  final String image;
  const ImageSection(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(image, width: double.infinity, fit: BoxFit.cover);
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

class JadwalSection extends StatefulWidget {
  final List<String> listHari;
  final List<String> listTanggal;
  final List<String> listJam;
  final String judulHari;
  final String judulJam;

  const JadwalSection({
    super.key,
    required this.listHari,
    required this.listTanggal,
    required this.listJam,
    required this.judulHari,
    required this.judulJam,
  });

  @override
  State<JadwalSection> createState() => _JadwalSectionState();
}

class _JadwalSectionState extends State<JadwalSection> {
  int? _hariPilih;
  int? _jamPilih;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul Hari
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 5),
          child: Text(widget.judulHari, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        // Pilihan Hari & Tanggal
        Container(
          height: 55,
          margin: const EdgeInsets.only(bottom: 15, left: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.listHari.length,
            itemBuilder: (context, index) {
              final hari = widget.listHari[index];
              final tanggal = widget.listTanggal[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _hariPilih = (_hariPilih == index) ? null : index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                  width: 70,
                  decoration: BoxDecoration(
                    color: _hariPilih == index ? const Color(0xFF3C5932) : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        hari,
                        style: TextStyle(
                          color: _hariPilih == index ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        tanggal,
                        style: TextStyle(
                          color: _hariPilih == index ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w900,
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
        // Judul Jam
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 5),
          child: Text(widget.judulJam, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        // Pilihan Jam
        Container(
          height: 40,
          margin: const EdgeInsets.only(bottom: 15, left: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.listJam.length,
            itemBuilder: (context, index) {
              final jam = widget.listJam[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _jamPilih = (_jamPilih == index) ? null : index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                  width: 70,
                  decoration: BoxDecoration(
                    color: _jamPilih == index ? const Color(0xFF3C5932) : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      jam,
                      style: TextStyle(
                        color: _jamPilih == index ? Colors.white : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
