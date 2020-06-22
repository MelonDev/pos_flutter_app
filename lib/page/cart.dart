import 'package:flutter/material.dart';
import 'package:posflutterapp/components/cart_products.dart';
import 'package:posflutterapp/page/scanner_page.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.purple),
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Text(
          'ตระกร้าสินค้า',
          style: TextStyle(
              color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new ScannerPage(),
              ),
            ),
            child: Icon(
              Icons.add_shopping_cart,
              color: Colors.purple,
            ),
          ),
        ],
      ),
      body: new Cart_Products(),

//      ListView(
//        children: <Widget>[
//          MaterialButton(
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(18.0)),
//            onPressed: () => ScanPage(),
//            child: new Text(
//              "เพิ่มสินค้า",
//              style: TextStyle(
//                  color: Colors.white,
//                  fontWeight: FontWeight.bold,
//                  fontSize: 20),
//            ),
//            color: Colors.orange,
//          ),
//
//        ],
//      ),
      bottomNavigationBar: new Container(
        height: 200,
        child: Material(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18))),
          color: Colors.purple,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 20,
                right: 20,
                top: 20,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: new Text(
                          "Total:",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        subtitle: new Text(
                          "จำนวน",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: ListTile(
                        title: new Text(
                          "500.-",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        subtitle: new Text(
                          "10",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                height: 60,
                left: 20,
                right: 20,
                bottom: 20,
                child: new MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  onPressed: () {},
                  child: new Text(
                    "ชำระเงิน",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
