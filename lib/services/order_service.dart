import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senada/models/order/order_model.dart';

class OrderService {
  final CollectionReference ordersRef = FirebaseFirestore.instance.collection('orders');
  final CollectionReference ticketsRef = FirebaseFirestore.instance.collection('tickets');

  // Menambahkan order ke Firestore
  Future<void> addOrder(TicketOrder order) async {
    try {
      await ordersRef.doc(order.orderId).set(order.toMap());
      print("Order berhasil ditambahkan.");
    } catch (e) {
      print("Gagal menambahkan order: $e");
      rethrow;
    }
  }

  // Mengambil order berdasarkan ID
  Future<TicketOrder?> getOrder(String orderId) async {
    try {
      final doc = await ordersRef.doc(orderId).get();
      if (doc.exists) {
        return TicketOrder.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Gagal mengambil order: $e");
      return null;
    }
  }

  // Mengupdate status pembayaran
  Future<void> updatePaymentStatus(String orderId, String? ticketsId, String newStatus, int? quantity) async {
    try {
      if (newStatus == 'success' && ticketsId != null && quantity != null) {
        final ticketDoc = await ticketsRef.doc(ticketsId).get();

        if (ticketDoc.exists) {
          final data = ticketDoc.data() as Map<String, dynamic>;
          final currentQuota = data['quota'] ?? 0;

          final updatedQuota = currentQuota - quantity;

          await ticketsRef.doc(ticketsId).update({
            'quota': updatedQuota,
          });
          print('Quota Ticker: $currentQuota');
        } else {
          print("Event tidak ditemukan.");
        }
      }

      await ordersRef.doc(orderId).update({
        'paymentStatus': newStatus,
        'status': newStatus,
      });
      print("Status pembayaran diperbarui.");
    } catch (e) {
      print("Gagal memperbarui status pembayaran: $e");
    }
  }

  // Mengambil semua order berdasarkan userId
  Future<List<TicketOrder>> getOrdersByUserId(String userId) async {
    try {
      final querySnapshot = await ordersRef
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        print('Data order yang diambil: $data');
        return TicketOrder.fromMap(data as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Gagal mengambil orders berdasarkan userId: $e");
      return [];
    }
  }

}
