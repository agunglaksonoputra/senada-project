import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  final String eventName;

  const ReservationPage({super.key, required this.eventName});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  int adultCount = 1;
  int childCount = 0;
  final int adultPrice = 150000;
  final int childPrice = 75000;
  final int serviceFee = 5000;

  int get totalPrice =>
      (adultCount * adultPrice) + (childCount * childPrice) + serviceFee;

  void incrementAdult() {
    if (adultCount + childCount < 10) {
      setState(() {
        adultCount++;
      });
    }
  }

  void decrementAdult() {
    if (adultCount > 0 && (adultCount + childCount) > 1) {
      setState(() {
        adultCount--;
      });
    }
  }

  void incrementChild() {
    if (adultCount + childCount < 10) {
      setState(() {
        childCount++;
      });
    }
  }

  void decrementChild() {
    if (childCount > 0 && (adultCount + childCount) > 1) {
      setState(() {
        childCount--;
      });
    }
  }


  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservasi Pertunjukan'),
        backgroundColor: const Color(0xFFB2A55D),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.eventName,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.calendar_today, size: 16),
                SizedBox(width: 5),
                Text('10 April 2025'),
              ],
            ),
            const Row(
              children: [
                Icon(Icons.access_time, size: 16),
                SizedBox(width: 5),
                Text('09.00 WITA'),
              ],
            ),
            const Row(
              children: [
                Icon(Icons.location_on, size: 16),
                SizedBox(width: 5),
                Text('Pura Uluwatu, Bali'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Pilihan Tiket',
                style: TextStyle(fontWeight: FontWeight.bold)),
            _buildTicketRow('Dewasa', adultPrice, adultCount, decrementAdult, incrementAdult, '9 tahun ke atas'),
            _buildTicketRow('Anak', childPrice, childCount, decrementChild, incrementChild, '2 - 8 tahun'),
            const SizedBox(height: 20),
            const Text('Detail Pembayaran',
                style: TextStyle(fontWeight: FontWeight.bold)),
            _buildDetailRow('Harga Tiket (${adultCount + childCount})', 'Rp ${((adultCount * adultPrice) + (childCount * childPrice)).toString()}'),
            _buildDetailRow('Biaya Layanan', 'Rp ${serviceFee.toString()}'),
            const Divider(),
            _buildDetailRow('Total', 'Rp ${totalPrice.toString()}'),
          ],
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
                Navigator.pushNamed(context, '/Login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A3663),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text('PESAN SEKARANG'),
            ),
          ),
          Container(
            height: 25,
            width: double.infinity,
            color: Colors.white,
          ),
        ],
      ),

    );
  }


  Widget _buildTicketRow(String label, int price, int count,
      VoidCallback onDecrease, VoidCallback onIncrease, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$label - Rp ${price.toString()}'),
              Text(subtitle, style: const TextStyle(fontSize: 12)),
            ],
          ),
          Row(
            children: [
              IconButton(onPressed: onDecrease, icon: const Icon(Icons.remove_circle_outline)),
              Text('$count'),
              IconButton(onPressed: onIncrease, icon: const Icon(Icons.add_circle_outline)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value)],
      ),
    );
  }
}
