import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/bloc/firebase_products/firebase_products_bloc.dart';
import 'package:posflutterapp/models/products_models.dart';
import 'package:posflutterapp/page/page_products_details.dart';

class Cart_Products extends StatefulWidget {
  @override
  _Cart_ProductsState createState() => _Cart_ProductsState();
}

class _Cart_ProductsState extends State<Cart_Products> {
  FirebaseProductsBloc _firebaseProductsBloc;
  Future<void> run() async {
    Firestore.instance.collection('products').snapshots().listen((value) {
      _firebaseProductsBloc.add(RefreshFirebaseProductsEvent(value));
      value.documents.forEach((element) {
        print(element.data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _firebaseProductsBloc = BlocProvider.of<FirebaseProductsBloc>(context);

    run();
    return BlocBuilder<FirebaseProductsBloc, FirebaseProductsState>(
      builder: (BuildContext context, _state) {
        print("HI");
        print(_state);
        if (_state is UpdatedFirebaseProductsState) {
          return ListView.builder(
              itemCount: _state.data.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Single_cart_product(_state.data[index]),
                );
              });
        } else {
          return Container(
            color: Colors.red,
          );
        }
      },
    );
  }
}

class Single_cart_product extends StatelessWidget {
  final Product _product;
  String _image;

  Single_cart_product(this._product);

  @override
  Widget build(BuildContext context) {
    _image = _product.image != null
        ? (_product.image.length > 0 ? _product.image[0] : "")
        : "";

    return Container(
      color: Colors.green,
      width: double.infinity,
      height: 120,
      child: Hero(
        tag: new Text("hero1"),
        child: Material(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetail(_product),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Align(
                    child: Container(
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            //color: Color(0x40000000),
                            child: _image.length > 0
                                ? Container(
                                    height: 120,
                                    child: Image.network(
                                      _image,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )
                                : Container(),
                          ),
                          Container(
                            //color: Color(0x40000000),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                _product.name ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.itim(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black87),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Container(
                              child: Text(
                                "${_product.salePrice}" + " ฿" ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.itim(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black87),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                new IconButton(
                                  icon: Icon(Icons.arrow_drop_up),
                                  onPressed: () {},
                                ),
                                new Text(
                                  "1",
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
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
