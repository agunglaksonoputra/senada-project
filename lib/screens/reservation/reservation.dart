import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:senada/models/events/event_model.dart';
import 'package:senada/models/order/order_model.dart';
import 'package:senada/models/order/ticket_order_model.dart';
import 'package:senada/models/ticket/ticket_category_model.dart';
import 'package:senada/models/ticket/ticket_model.dart';
import 'package:senada/screens/reservation/payment.dart';
import 'package:senada/services/Auth/auth_service.dart';
import 'package:senada/services/order_service.dart';
import 'package:senada/services/tickets/ticket_service.dart';
import 'package:senada/widgets/payment_selector.dart';

class ReservationPage extends StatefulWidget {
  final Event event;
  final Ticket ticket;

  const ReservationPage({
    super.key,
    required this.event,
    required this.ticket,
  });

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TicketService _ticketService = TicketService();
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService();

  List<TicketCategory> subcategories = [];
  Map<String, int> ticketCounts = {};
  final int serviceFee = 5000;
  late PaymentMethod _selectedMethod;
  bool _isOrdering = false;

  @override
  void initState() {
    super.initState();
    fetchCategory();
    _selectedMethod = PaymentMethodList.allCategories[0].methods[0];
  }

  Future<void> fetchCategory() async {
    try {
      final category = await _ticketService.fetchSubcategories(widget.ticket.subcategoryIds);
      setState(() {
        subcategories = category;
        for (var sub in category) {
          ticketCounts[sub.id] = 0;
        }
      });
    } catch (e) {
      print('Error fetching subcategories: $e');
    }
  }

  Future<void> storeOrder() async {
    if (_authService.currentUser == null) {
      Navigator.pushNamed(context, '/Login');
      return;
    }

    final int totalTickets = ticketCounts.values.fold(0, (a, b) => a + b);
    if (totalTickets == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal 1 tiket')),
      );
      return;
    }

    setState(() {
      _isOrdering = true;
    });

    try {
      final userId = _authService.currentUser!.uid;

      List<OrderTicket> ticketsOrdered = [];
      for (var sub in subcategories) {
        final count = ticketCounts[sub.id] ?? 0;
        if (count > 0) {
          ticketsOrdered.add(OrderTicket(
            id: sub.id,
            event: widget.event.title,
            name: sub.name, // Ini sudah menggunakan nama subcategory
            sessionStartTime: widget.ticket.sessionStartTime,
            sessionStartDate: widget.ticket.sessionStartDate,
            quantity: count,
          ));
        }
      }

      final order = TicketOrder(
        orderId: 'SND${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        ticketId: widget.ticket.id,
        event: {
          'id': widget.event.id,
          'title': widget.event.title,
        },
        tickets: ticketsOrdered,
        totalPrice: totalPrice,
        paymentMethod: _selectedMethod.name,
        paymentStatus: 'pending',
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await _orderService.addOrder(order);

      // Navigasi ke halaman pembayaran setelah order berhasil dibuat
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(
              data: {
                'order': order,
                'paymentMethod': _selectedMethod,
                'totalTickets': totalTickets,
                'ticket': widget.ticket.id,
              },
          ),
        ),
      );
      print('totalTickets: $totalTickets');

    } catch (e) {
      print('Error saat order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat order: $e')),
      );
    } finally {
      setState(() {
        _isOrdering = false;
      });
    }
  }

  void incrementTicket(String id) {
    setState(() {
      final total = ticketCounts.values.fold(0, (a, b) => a + b);
      final maxAllowed = widget.ticket.quota <= 10 ? widget.ticket.quota : 10;
      if (total < maxAllowed) {
        ticketCounts[id] = (ticketCounts[id] ?? 0) + 1;
      }
    });
  }

  void decrementTicket(String id) {
    setState(() {
      final total = ticketCounts.values.fold(0, (a, b) => a + b);
      final current = ticketCounts[id] ?? 0;
      if (current > 0 && total > 0) {
        ticketCounts[id] = current - 1;
      }
    });
  }

  String formatRupiah(int number) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(number);
  }

  int get totalPrice {
    int price = 0;
    for (var sub in subcategories) {
      final count = ticketCounts[sub.id] ?? 0;
      price += count * sub.price;
    }
    return price + serviceFee;
  }

  void _onMethodSelected(PaymentMethod method) {
    setState(() {
      _selectedMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalTickets = ticketCounts.values.fold(0, (a, b) => a + b);
    final bool isButtonEnabled = totalTickets > 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.angleLeft, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Reservasi Pertunjukan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFFB2A55D),
        foregroundColor: Colors.white,
        toolbarHeight: 60,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: subcategories.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF6F8878),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.event.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.solidCalendarDays, size: 20, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(widget.ticket.formattedStartDate, style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.solidClock, size: 16, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(widget.ticket.sessionStartTime, style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FaIcon(FontAwesomeIcons.locationDot, size: 20, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(widget.event.location,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text('Pilihan Tiket', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

              ...subcategories.map((sub) {
                final count = ticketCounts[sub.id] ?? 0;
                return _buildTicketRow(
                  sub.name,
                  sub.price,
                  count,
                      () => decrementTicket(sub.id),
                      () => incrementTicket(sub.id),
                  sub.description ?? '',
                );
              }).toList(),

              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Detail Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  _buildDetailRow('Harga Tiket (${ticketCounts.values.fold(0, (a, b) => a + b)})',
                      '${formatRupiah(totalPrice - serviceFee)}'),
                  _buildDetailRow('Biaya Layanan', '${formatRupiah(serviceFee)}'),
                  const Divider(),
                  _buildDetailRow('Total', '${formatRupiah(totalPrice)}'),
                ],
              ),

              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Metode Pembayaran',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  PaymentMethodSelector(
                    categories: PaymentMethodList.allCategories,
                    selectedMethod: _selectedMethod,
                    onSelected: _onMethodSelected,
                  ),
                ],
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
              onPressed: isButtonEnabled ? storeOrder : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonEnabled ? const Color(0xFF2A3663) : Colors.grey,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: _isOrdering
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('PESAN SEKARANG'),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTicketRow(
      String label,
      int price,
      int count,
      VoidCallback onDecrease,
      VoidCallback onIncrease,
      String subtitle,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$label - ${formatRupiah(price)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                if (subtitle.isNotEmpty)
                  Text(subtitle, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: onDecrease,
                icon: const FaIcon(FontAwesomeIcons.circleMinus, color: Color(0xFF2A3663)),
              ),
              Text('$count', style: const TextStyle(fontSize: 16)),
              IconButton(
                onPressed: onIncrease,
                icon: const FaIcon(FontAwesomeIcons.circlePlus, color: Color(0xFF2A3663)),
              ),
            ],
          )
        ],
      ),
    );
  }
}