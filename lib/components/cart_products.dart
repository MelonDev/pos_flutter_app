import 'package:flutter/material.dart';

class Cart_Products extends StatefulWidget {
  @override
  _Cart_ProductsState createState() => _Cart_ProductsState();
}

class _Cart_ProductsState extends State<Cart_Products> {
  var Products_on_the_cart = [
    {
      "name": "Fanta",
      "picture": "images/products/fanta01.jpg",
      "price": 10,
      "quantity": 1,
    },
    {
      "name": "Lay",
      "picture": "images/products/lay01.jpg",
      "price": 18,
      "quantity": 1,
    },
    {
      "name": "Coke Zero",
      "picture": "images/products/coke-zero01.jpg",
      "price": 10,
      "quantity": 1,
    },
    {
      "name": "Lay",
      "picture": "images/products/lay02.jpg",
      "price": 18,
      "quantity": 1,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: Products_on_the_cart.length,
        itemBuilder: (context, index) {
          return Single_caer_product(
            cart_prod_name: Products_on_the_cart[index]["name"],
            cart_prod_picture: Products_on_the_cart[index]["picture"],
            cart_prod_price: Products_on_the_cart[index]["price"],
            cart_prod_quantity: Products_on_the_cart[index]["quantity"],
          );
        });
  }
}

class Single_caer_product extends StatelessWidget {
  final cart_prod_name;
  final cart_prod_picture;
  final cart_prod_price;
  final cart_prod_quantity;

  Single_caer_product({
    this.cart_prod_name,
    this.cart_prod_picture,
    this.cart_prod_price,
    this.cart_prod_quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    leading: new Image.asset(
                      cart_prod_picture,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: new Text(
                      cart_prod_name,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    subtitle: new Text(
                      "จำนวน",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  child: ListTile(
                    title: new Text(
                      "$cart_prod_price\.-",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: new Column(
                      children: <Widget>[
                        new IconButton(
                          icon: Icon(Icons.arrow_drop_up),
                          onPressed: () {},
                        ),
                        new Text(
                          "$cart_prod_quantity",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        new IconButton(
                          icon: Icon(Icons.arrow_drop_down),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
