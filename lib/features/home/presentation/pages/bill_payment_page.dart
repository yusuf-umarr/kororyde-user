import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BillPaymentPage extends StatelessWidget {
      static const String routeName = '/billPayment';

  const BillPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
      return  Scaffold(
      appBar: AppBar(
        title: Text("Bill Payment"),
      ),
    );
  }
}