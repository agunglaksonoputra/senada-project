import 'dart:math';

import 'package:flutter/material.dart';
import 'package:senada/Screens/reservation/reservation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              // Add your onPressed code here!
            },
          ),
          backgroundColor: Color(0xFFB2A55D),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ImageSection(image: 'assets/images/tari_kecak.jpg'),
                TitleSection(
                  name: "Pertunjukan Tari Kecak & Api di Uluwatu",
                  rating: 10,
                  reviewCount: 190,
                ),
                // RatingDetail(
                //   rating: 10,
                //   reviewCount: 190,
                // ),
                TextSection(
                  deskripsi:
                      "Tari Kecak dan Api Uluwatu adalah pertunjukan seni tradisional Bali yang menggabungkan tarian, drama, dan unsur spiritual. Tarian ini dikenal karena kekuatan vokal para penarinya yang duduk melingkar dan melantunkan 'cak, cak, cak' secara berirama tanpa iringan alat musik. Pertunjukan ini menggambarkan kisah epik Ramayana, khususnya bagian di mana Rama berjuang menyelamatkan Sita dari Rahwana, dibantu oleh Hanoman.",
                ),

                JadwalSection(
                  judul: "Jadwal Pertunjukan",
                  listHari: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'sun'],
                  listTanggal: ['1', '2', '3', '4', '5', '6', '7'],
                ),

                JamSection(
                  listJam: [
                    "13.00",
                    "13.00",
                    "13.00",
                    "13.00",
                    "13.00",
                    "13.00",
                    "13.00",
                    "13.00",
                    "13.00",
                  ],
                  judul: "Waktu Pertunjukan",
                ),

                InformasiSection(
                  name: "Detail Informasi",
                  telepon: "+62 8123456789",
                  lokasi:
                      "Pura Uluwatu. Pecatu, Kuta Selatan, Kabupaten Badung, Bali, Indonesia",
                ),

                TextSection(
                  deskripsi: "Langsung saksikan Tari Kecak dan Api di Pura Uluwatu, pertunjukan budaya paling ikonik di Bali! Bayangkan duduk di tepi tebing, ditemani suara deburan ombak dan matahari terbenam, sambil menikmati kisah epik Ramayana yang ditampilkan secara dramatis dan penuh semangat.\n\n"
                      "\u2022 Rasakan atmosfer yang magis saat puluhan penari pria bersuara 'cak-cak-cak' dalam harmoni, membentuk irama yang bikin merinding \n"
                      "\u2022 Saksikan aksi para penari menari di atas bara api, sebuah pertunjukan berani yang memukau \n"
                      "\u2022 Nggak cuma nonton – kamu bisa larut dalam suasana dan diajak ikut teriak bersama, seru banget! \n"
                      "\u2022 Wajib bawa kamera – momen sunset, para penari, dan pura Uluwatu jadi latar Instagramable yang nggak ada duanya \n\n"

                    "Kalau kamu lagi liburan ke Bali, Pura Luhur Uluwatu adalah destinasi wajib. Tari Kecak dan Api di sini bukan hanya tontonan, tapi pengalaman budaya yang menyentuh hati."

                    "Rasakan keajaiban budaya Bali, langsung dari tempat paling eksotis di pulau dewata. Jangan sampai ketinggalan ya!",
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationPage(
                      eventName: "Pertunjukan Tari Kecak & Api di Uluwatu",
                    ),

                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A3663),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('BELI TIKET SEKARANG'),
              ),
            ),
            Container(
              height: 25,
              width: double.infinity,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({super.key, this.image});

  final String? image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(image!, width: 415, fit: BoxFit.cover);
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.name,
    this.rating,
    this.reviewCount,
  });

  final String name;
  final double? rating;
  final int? reviewCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFb2a55d),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 20),
                      const SizedBox(width: 1),
                      Text(
                        '${rating?.toStringAsFixed(0)}/10',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$reviewCount ulasan',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({super.key, this.deskripsi});

  final String? deskripsi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
      child: Text(
        deskripsi!,
        softWrap: true,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class JadwalSection extends StatefulWidget {
  const JadwalSection({
    super.key,
    required this.listHari,
    required this.listTanggal,
    required this.judul,
  });

  final List<String> listHari;
  final List<String> listTanggal;

  final String judul;

  @override
  State<JadwalSection> createState() => _JadwalSectionState();
}

class _JadwalSectionState extends State<JadwalSection> {
  int? _hariPilih;

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 5),
          child: Text(
            widget.judul,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        Container(
          height: 55,
          margin: const EdgeInsets.only(top: 10, left: 15, bottom: 15),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(widget.listHari.length, (index) {
              String hari = widget.listHari[index];
              String tanggal = widget.listTanggal[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (_hariPilih == index) {
                      _hariPilih = null;
                    } else {
                      _hariPilih = index;
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 10,
                  ),
                  width: 70,
                  decoration: BoxDecoration(
                    color:
                        _hariPilih == index
                            ? const Color(0xFF3C5932)
                            : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hari,
                        style: TextStyle(
                          color:
                              _hariPilih == index ? Colors.white : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        tanggal,
                        style: TextStyle(
                          color:
                              _hariPilih == index ? Colors.white : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class JamSection extends StatefulWidget {
  const JamSection({super.key, required this.listJam, required this.judul});

  final List<String> listJam;
  final String judul;

  @override
  State<JamSection> createState() => _JamSectionState();
}

class _JamSectionState extends State<JamSection> {
  int? _jamPilih;

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 5),
          child: Text(
            widget.judul,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 15, bottom: 15),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(widget.listJam.length, (index) {
              String jam = widget.listJam[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (_jamPilih == index) {
                      _jamPilih = null;
                    } else {
                      _jamPilih = index;
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 10,
                  ),
                  width: 70,
                  decoration: BoxDecoration(
                    color:
                        _jamPilih == index
                            ? const Color(0xFF3C5932)
                            : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        jam,
                        style: TextStyle(
                          color:
                              _jamPilih == index ? Colors.white : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class InformasiSection extends StatelessWidget {
  const InformasiSection({
    super.key,
    required this.name,
    this.lokasi,
    this.telepon,
  });

  final String name;
  final String? lokasi;
  final String? telepon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only( bottom: 10, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 40, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF3C5932),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        lokasi!,
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10), // jarak antar baris
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.phone, color: Color(0xFF3C5932), size: 20),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        telepon!,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
