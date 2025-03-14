import 'package:flutter/material.dart';

class AdvertPage extends StatelessWidget {
  static const String routeName = '/advert';

  const AdvertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advert"),
      ),
      body: Center(
        child: Text("Advert"),
      ),
    );
  }
}
