import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'POS SHOP',
          style: TextStyle(
              color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 50),
        ),
      ),
    );
  }
}
