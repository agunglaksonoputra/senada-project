// payment_method_selector.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentMethod {
  final String name;
  final String assetPath;

  PaymentMethod({required this.name, required this.assetPath});
}

class PaymentMethodCategory {
  final String categoryName;
  final List<PaymentMethod> methods;

  PaymentMethodCategory({required this.categoryName, required this.methods});
}

// ✅ Daftar metode disimpan di sini agar bisa digunakan di banyak tempat
class PaymentMethodList {
  static final List<PaymentMethodCategory> allCategories = [
    PaymentMethodCategory(
      categoryName: 'Other',
      methods: [
        PaymentMethod(name: 'QRIS', assetPath: 'assets/images/E_Wallet/QRIS.png'),
      ],
    ),
    PaymentMethodCategory(
      categoryName: 'E-Wallet',
      methods: [
        PaymentMethod(name: 'Dana', assetPath: 'assets/images/E_Wallet/DANA.png'),
        PaymentMethod(name: 'Gopay', assetPath: 'assets/images/E_Wallet/Gopay.png'),
        PaymentMethod(name: 'OVO', assetPath: 'assets/images/E_Wallet/OVO.png'),
        PaymentMethod(name: 'Shopee Pay', assetPath: 'assets/images/E_Wallet/Shopee_Pay.png'),
      ],
    ),
    PaymentMethodCategory(
      categoryName: 'Bank',
      methods: [
        PaymentMethod(name: 'Bank Mandiri', assetPath: 'assets/images/Bank_Logo/Mandiri.png'),
        PaymentMethod(name: 'Bank BRI', assetPath: 'assets/images/Bank_Logo/BRI.png'),
        PaymentMethod(name: 'Bank BCA', assetPath: 'assets/images/Bank_Logo/BCA.png'),
        PaymentMethod(name: 'Bank BNI', assetPath: 'assets/images/Bank_Logo/BNI.png'),
      ],
    ),
  ];
  // static final List<PaymentMethod> all = [
  //   PaymentMethod(name: 'Bank Mandiri', assetPath: 'assets/images/Bank_Logo/Mandiri.png'),
  //   PaymentMethod(name: 'Bank BRI', assetPath: 'assets/images/Bank_Logo/BRI.png'),
  //   PaymentMethod(name: 'Bank BCA', assetPath: 'assets/images/Bank_Logo/BCA.png'),
  //   PaymentMethod(name: 'Bank BNI', assetPath: 'assets/images/Bank_Logo/BNI.png'),
  // ];
}

class PaymentMethodSelector extends StatefulWidget {
  final List<PaymentMethodCategory> categories;
  final PaymentMethod selectedMethod;
  final Function(PaymentMethod) onSelected;

  const PaymentMethodSelector({
    Key? key,
    required this.categories,
    required this.selectedMethod,
    required this.onSelected,
  }) : super(key: key);

  @override
  _PaymentMethodSelectorState createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  late PaymentMethod _selectedMethod;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.selectedMethod;
  }

  void _showPaymentMethods() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Pilih Metode Pembayaran",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: PaymentMethodList.allCategories.length,
                itemBuilder: (context, categoryIndex) {
                  final category = PaymentMethodList.allCategories[categoryIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          category.categoryName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...category.methods.map((method) => ListTile(
                        leading: Image.asset(method.assetPath, width: 40, height: 40),
                        title: Text(method.name),
                        trailing: const FaIcon(FontAwesomeIcons.angleRight),
                        onTap: () {
                          setState(() {
                            _selectedMethod = method;
                          });
                          widget.onSelected(_selectedMethod);
                          Navigator.pop(context);
                        },
                      )),
                      const Divider(height: 1),
                    ],
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
    return GestureDetector(
      onTap: _showPaymentMethods,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Image.asset(_selectedMethod.assetPath, width: 50, height: 50),
              const SizedBox(width: 16),
              Text(_selectedMethod.name, style: TextStyle(fontSize: 16)),
              Spacer(),
              FaIcon(FontAwesomeIcons.angleRight),
            ],
          ),
        ),
      ),
    );
  }
}
