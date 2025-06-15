import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:senada/models/order/order_model.dart';
import 'package:senada/services/order_service.dart';
import 'package:senada/widgets/payment_selector.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const PaymentPage({
    super.key,
    required this.data,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final OrderService _orderService = OrderService();
  late TicketOrder order;
  late PaymentMethod _paymentMethod;
  late int _totalTickets;
  bool _isProcessing = false;
  String _paymentStatus = 'pending';
  int _remainingTime = 300;
  bool _timeExpired = false;

  @override
  void initState() {
    super.initState();
    order = widget.data['order'];
    _paymentMethod = widget.data['paymentMethod'];
    _totalTickets = widget.data['totalTickets'];
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _remainingTime > 0 && !_timeExpired) {
        setState(() {
          _remainingTime--;
        });
        _startTimer();
      } else if (mounted && _remainingTime <= 0 && !_timeExpired) {
        _handleTimeExpired();
      }
    });
  }

  Future<void> _handleTimeExpired() async {
    setState(() {
      _timeExpired = true;
    });

    // Update payment status to failed
    await _orderService.updatePaymentStatus(order.orderId, order.event['id'] , 'failed', _totalTickets);

    if (mounted) {
      // Show time expired dialog
      _showTimeExpiredDialog();
    }
  }

  void _showTimeExpiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.clock,
                  color: Colors.orange,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Waktu Pembayaran Habis',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Waktu pembayaran telah berakhir. Silakan buat pesanan baru.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A3663),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Kembali ke Beranda'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatRupiah(double number) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(number);
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _processPayment() async {
    // Check if time has expired before processing
    if (_timeExpired || _remainingTime <= 0) {
      _showTimeExpiredDialog();
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulasi proses pembayaran
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isProcessing = false;
      _paymentStatus = 'success';
    });

    if (_paymentStatus == 'success') {
      await _orderService.updatePaymentStatus(order.orderId, widget.data['ticket'], 'success', _totalTickets);
      _showSuccessDialog();
    } else {
      await _orderService.updatePaymentStatus(order.orderId, null, 'failed', null);
      _showFailedDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.check,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pembayaran Berhasil!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Order ID: ${order.orderId}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A3663),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Kembali ke Beranda'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showFailedDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.xmark,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pembayaran Gagal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Silakan coba lagi atau pilih metode pembayaran lain',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2A3663),
                        side: const BorderSide(color: Color(0xFF2A3663)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/',
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A3663),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Kembali'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleBackPressed() async {
    // Show confirmation dialog before cancelling payment
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Batalkan Pembayaran?'),
          content: const Text(
            'Jika Anda keluar sekarang, pembayaran akan dibatalkan dan pesanan tidak akan diproses.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tetap di Sini'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog

                // Update payment status to cancelled
                await _orderService.updatePaymentStatus(order.orderId, widget.data['ticket'], 'cancelled', null);

                // Navigate to home and remove all previous routes
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                        (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Batalkan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.angleLeft, color: Colors.white),
          onPressed: () => _handleBackPressed(),
        ),
        title: const Text(
          'Pembayaran',
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimerCard(),
            const SizedBox(height: 20),
            _buildPaymentMethodCard(),
            const SizedBox(height: 20),
            _buildOrderSummary(),
            const SizedBox(height: 20),
            _buildInstructions(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (_isProcessing || _timeExpired || _remainingTime <= 0)
                    ? null
                    : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A3663),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isProcessing
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('Memproses...'),
                  ],
                )
                    : Text(
                  _timeExpired || _remainingTime <= 0
                      ? 'WAKTU HABIS'
                      : 'KONFIRMASI PEMBAYARAN',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Dengan melanjutkan, Anda menyetujui syarat dan ketentuan',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    _paymentMethod = widget.data['paymentMethod'];

    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF2A3663), const Color(0xFF2A3663).withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2A3663).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  // padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                      _paymentMethod.assetPath,
                      fit: BoxFit.contain,
                      width: 50, height: 50
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _paymentMethod.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Metode Pembayaran Dipilih',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Column(
              children: [
                if (_paymentMethod.name == 'QRIS')
                  Container(
                    child: Image.asset('assets/images/E_Wallet/qr-code.png'),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Virtual Number', style: TextStyle(color: Colors.white)),
                        Text('649104484187', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))
                      ],
                    ),
                  ),
              ],
            )

          ],
        )
    );
  }

  Widget _buildOrderSummary() {
    int totalTickets = order.tickets.fold(0, (sum, ticket) => sum + ticket.quantity);

    String eventName = order.tickets.isNotEmpty
        ? 'Event'
        : 'Unknown Event';

    // Format tanggal dari tiket pertama
    String eventDate = order.tickets.isNotEmpty
        ? DateFormat('dd MMMM yyyy', 'id_ID').format(order.tickets.first.sessionStartDate)
        : 'Unknown Date';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF6F8878).withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF6F8878).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.ticket, color: Color(0xFF6F8878), size: 20),
              const SizedBox(width: 10),
              const Text(
                'Ringkasan Pesanan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6F8878),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildSummaryRow('Order ID', order.orderId),
          _buildSummaryRow('Event', eventName),
          _buildSummaryRow('Tanggal', eventDate),
          _buildSummaryRow('Jumlah Tiket', '$totalTickets tiket'),
          const Divider(color: Color(0xFF6F8878)),
          _buildSummaryRow(
            'Total Pembayaran',
            formatRupiah(widget.data['order'].totalPrice.toDouble()),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    List<String> steps = [];

    steps = [
      'Ikuti instruksi pembayaran',
      'Masukkan detail yang diperlukan',
      'Konfirmasi pembayaran',
      'Tunggu konfirmasi'
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.listCheck, color: Colors.blue, size: 20),
              const SizedBox(width: 10),
              const Text(
                'Cara Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...steps.asMap().entries.map((entry) {
            int index = entry.key;
            String step = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFF2A3663) : Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? const Color(0xFF2A3663) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _timeExpired || _remainingTime <= 0
            ? Colors.grey.shade50
            : Colors.red.shade50,
        border: Border.all(
            color: _timeExpired || _remainingTime <= 0
                ? Colors.grey.shade300
                : Colors.red.shade200
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _timeExpired || _remainingTime <= 0
                  ? Colors.grey.shade100
                  : Colors.red.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FaIcon(
                FontAwesomeIcons.clock,
                color: _timeExpired || _remainingTime <= 0
                    ? Colors.grey
                    : Colors.red,
                size: 20
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _timeExpired || _remainingTime <= 0
                      ? 'Waktu Habis'
                      : 'Waktu Tersisa',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _timeExpired || _remainingTime <= 0
                      ? '00:00'
                      : _formatTime(_remainingTime),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _timeExpired || _remainingTime <= 0
                        ? Colors.grey
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _timeExpired || _remainingTime <= 0
                ? 'Waktu pembayaran telah berakhir'
                : 'Segera lakukan pembayaran',
            style: TextStyle(
              fontSize: 12,
              color: _timeExpired || _remainingTime <= 0
                  ? Colors.grey.shade600
                  : Colors.red.shade600,
            ),
          ),
        ],
      ),
    );
  }
}