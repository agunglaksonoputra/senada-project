import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CulturalShowPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class CulturalShowPage extends StatefulWidget {
  const CulturalShowPage({super.key});

  @override
  _CulturalShowPageState createState() => _CulturalShowPageState();
}

class _CulturalShowPageState extends State<CulturalShowPage> {
  final List<String> daerahList = [
    "JAWA BARAT",
    "JAKARTA",
    "SUMATRA BARAT",
    "SUMATRA SELATAN",
    "JAWA TENGAH",
    "YOGYAKARTA",
    "BANTEN",
    "BALI"
  ];

  String selectedDaerah = "BALI";

  List<Map<String, String>> getShowList() {
    if (selectedDaerah == "BALI") {
      return List.generate(8, (_) => {
            "title": "Tari Kecak & Api Uluwatu",
            "description":
                "Pertunjukan seni tradisional Bali yang menggabungkan tarian, drama, dan unsur spiritual. Tarian ini dikenal karena kekuatan vokal para penarinya yang duduk melingkar dan melantunkan “cak, cak, cak” secara berirama tanpa iringan alat musik.",
            "image": "assets/images/Frame28.png",
          });
    }
    return [];
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
            height: 400, // tinggi modal bisa disesuaikan
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Pilih Daerah', style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),

                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: daerahList.map((daerah) {
                        return ListTile(
                          title: Text(
                            daerah,
                            style: TextStyle(
                              color: daerah == selectedDaerah ? Colors.green : null,
                              fontWeight: daerah == selectedDaerah ? FontWeight.bold : null,
                            ),
                          ),
                          trailing: daerah == selectedDaerah
                              ? Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            setState(() {
                              selectedDaerah = daerah;
                            });
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
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
    final showList = getShowList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFFb2a55d),
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
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
                    Icon(Icons.place, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text(
                      selectedDaerah,
                      style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w600),
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
              Text("Tempat Pertunjukan Seni Tari",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: showList.length,
                  itemBuilder: (context, index) {
                    final show = showList[index];
                    return Container(
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
                          // Gambar di kiri
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              show['image']!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          
                          // Judul dan Deskripsi
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  show['title']!,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  show['description']!,
                                  style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
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
