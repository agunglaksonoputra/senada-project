import 'package:flutter/material.dart';

void main() => runApp(const DetailPage());

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

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
                ImageSection("assets/images/tari_kecak.jpg"),
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

                const JadwalSection(
                  listHari: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
                  listTanggal: ['1', '2', '3', '4', '5', '6', '7'],
                  listJam: [
                    "13.00",
                    "13.00",
                    "13.00",
                    "13.00",
                    "13.00",
                    "13.00",
                    "13.00",
                  ],
                  judulHari: "Tanggal Pertunjukan",
                  judulJam: "Jam Pertunjukan",
                ),

                InformasiSection(
                  name: "Detail Informasi",
                  telepon: "+62 8123456789",
                  lokasi:
                      "Pura Uluwatu. Pecatu, Kuta Selatan, Kabupaten Badung, Bali, Indonesia",
                ),

                const TextSection(
                  deskripsi:
                      "Langsung saksikan Tari Kecak dan Api di Pura Uluwatu...\n\n\u2022 Rasakan atmosfer...\n\u2022 Saksikan aksi...\n\u2022 Nggak cuma nonton...\n\u2022 Wajib bawa kamera...\n\nKalau kamu lagi liburan...",
                ),
                BeliTiketButton(
                  title: "Beli Tiket",
                  icon: Icons.payment_outlined,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/Register',
                    ); // Mengarahkan ke halaman Register
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           color: Colors.white,
//           onPressed: () {
//             Navigator.pop(context); // Ini untuk kembali ke halaman sebelumnya
//           },
//         ),
//         backgroundColor: const Color(0xFFB2A55D),
//       ),
//       body: const SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 10),
//             child: KecakContent(),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class KecakContent extends StatelessWidget {
//   const KecakContent({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const ImageSection('assets/images/tari_kecak.jpg'),
//         const TitleSection(
//           name: "Pertunjukan Tari Kecak & Api di Uluwatu",
//           rating: 10,
//           reviewCount: 190,
//         ),
//         const TextSection(
//           deskripsi:
//           "Tari Kecak dan Api Uluwatu adalah pertunjukan seni tradisional Bali...",
//         ),
//         const JadwalSection(
//           listHari: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
//           listTanggal: ['1', '2', '3', '4', '5', '6', '7'],
//           listJam: [
//             "13.00",
//             "13.00",
//             "13.00",
//             "13.00",
//             "13.00",
//             "13.00",
//             "13.00",
//           ],
//           judulHari: "Tanggal Pertunjukan",
//           judulJam: "Jam Pertunjukan",
//         ),
//         const InformasiSection(
//           name: "Detail Informasi",
//           telepon: "+62 8123456789",
//           lokasi:
//           "Pura Uluwatu. Pecatu, Kuta Selatan, Kabupaten Badung, Bali, Indonesia",
//         ),
//         const TextSection(
//           deskripsi:
//           "Langsung saksikan Tari Kecak dan Api di Pura Uluwatu...\n\n\u2022 Rasakan atmosfer...\n\u2022 Saksikan aksi...\n\u2022 Nggak cuma nonton...\n\u2022 Wajib bawa kamera...\n\nKalau kamu lagi liburan...",
//         ),
//         BeliTiketButton(
//           title: "Beli Tiket",
//           icon: Icons.payment_outlined,
//           onPressed: () {
//             Navigator.pushNamed(
//                 context, '/Register'); // Mengarahkan ke halaman Register
//           },
//         ),
//       ],
//     );
//   }
// }

class ImageSection extends StatelessWidget {
  const ImageSection(this.image);

  final String? image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(image!, width: double.infinity, fit: BoxFit.cover);
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
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
  final String deskripsi;

  const TextSection({super.key, required this.deskripsi});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        deskripsi,
        textAlign: TextAlign.justify,
        style: const TextStyle(fontSize: 14),
      ),
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
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Color(0xFF3C5932), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  lokasi,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.phone, color: Color(0xFF3C5932), size: 20),
              const SizedBox(width: 10),
              Text(
                telepon,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
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
        // --- Judul Hari ---
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 5),
          child: Text(
            widget.judulHari,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        // --- Pilihan Hari & Tanggal ---
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
            },
          ),
        ),

        // --- Judul Jam ---
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 5),
          child: Text(
            widget.judulJam,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        // --- Pilihan Jam ---
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

class BeliTiketButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const BeliTiketButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 30),
          FilledButton.icon(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: Color(0xFF3C5932),
              fixedSize: const Size(200, 50),
            ),
            icon: Icon(icon),
            label: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// Untuk JadwalSection dan JamSection, karena perlu StatefulWidget, bisa tetap dibuat secara terpisah
// atau dikombinasikan jika fungsinya mirip. Namun untuk kesederhanaan struktur, kita tetap gunakan class terpisah.
