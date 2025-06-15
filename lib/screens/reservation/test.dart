import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MaterialApp(home: PaymentMethodPage()));

class PaymentMethod {
  final String name;
  final String assetPath;

  PaymentMethod({required this.name, required this.assetPath});
}

class PaymentMethodPage extends StatefulWidget {
  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  PaymentMethod _selectedMethod = PaymentMethod(
    name: 'Bank Mandiri',
    assetPath: 'assets/images/Bank_Logo/Mandiri.png',
  );

  final List<PaymentMethod> _methods = [
    PaymentMethod(name: 'Bank Mandiri', assetPath: 'assets/images/Bank_Logo/Mandiri.png'),
    PaymentMethod(name: 'Bank BRI', assetPath: 'assets/images/Bank_Logo/BRI.png'),
    PaymentMethod(name: 'Bank BCA', assetPath: 'assets/images/Bank_Logo/BCA.png'),
  ];

  void _showPaymentMethods() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title and Close Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "Pilih Metode Pembayaran",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Divider(height: 1),

            // Payment method list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _methods.length,
                itemBuilder: (ctx, i) {
                  return ListTile(
                    leading: Image.asset(_methods[i].assetPath, width: 40, height: 40),
                    title: Text(_methods[i].name),
                    trailing: FaIcon(FontAwesomeIcons.angleRight),
                    onTap: () {
                      setState(() {
                        _selectedMethod = _methods[i];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pilih Metode Pembayaran")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Metode Pembayaran", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _showPaymentMethods,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Image.asset(_selectedMethod.assetPath, width: 50, height: 50),
                      const SizedBox(width: 16),
                      Text(
                        _selectedMethod.name,
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      FaIcon(FontAwesomeIcons.angleRight),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
