import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.shopping_cart,
              color: Colors.purple,
              size: 100,
            ), // icon
            Text(
              "POS SHOP",
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 60,
                  fontWeight: FontWeight.bold),
            ), // text
          ],
        ),
      ),
    );
  }
}
