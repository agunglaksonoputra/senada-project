import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senada/models/order/order_model.dart';
import 'package:senada/services/Auth/auth_service.dart';
import 'package:senada/services/order_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final AuthService _authService = AuthService();
  final OrderService _orderService = OrderService();

  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _authService.checkUser();
  }

  Future<List<TicketOrder>> _getUserOrders(String uid) async {
    print(uid);
    return await _orderService.getOrdersByUserId(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshotUser) {
          if (snapshotUser.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshotUser.hasData || snapshotUser.data == null) {
            return const Center(
              child: Text(
                'Silakan login untuk melihat riwayat pesanan.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final user = snapshotUser.data!;

          return FutureBuilder<List<TicketOrder>>(
            future: _getUserOrders(user.uid),
            builder: (context, snapshotOrder) {
              if (snapshotOrder.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshotOrder.hasError) {
                return Center(
                  child: Text('Terjadi kesalahan: ${snapshotOrder.error}'),
                );
              }

              final orders = snapshotOrder.data;

              if (orders == null || orders.isEmpty) {
                return const Center(child: Text('Belum ada riwayat pesanan.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID Order: ${order.orderId}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Event: ${order.event['title'] ?? 'N/A'}'),
                          Text('Jumlah Tiket: ${order.totalQuantity}'),
                          Text('Total Harga: Rp${order.totalPrice}'),
                          Text('Status Pembayaran: ${order.paymentStatus}'),
                          Text('Waktu Pemesanan: ${order.formattedCreatedAt}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
