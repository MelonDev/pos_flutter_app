import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';
import 'package:posflutterapp/bloc/firebase_products/firebase_products_bloc.dart';
import 'package:posflutterapp/models/ProductPack.dart';
import 'package:posflutterapp/models/products_models.dart';
import 'package:posflutterapp/page/page_products_details.dart';

class Cart_Products extends StatefulWidget {
  @override
  _Cart_ProductsState createState() => _Cart_ProductsState();
}

class _Cart_ProductsState extends State<Cart_Products> {
  FirebaseProductsBloc _firebaseProductsBloc;

  List<ProductPack> _listProductPack = [];

  @override
  Widget build(BuildContext context) {
    _firebaseProductsBloc = BlocProvider.of<FirebaseProductsBloc>(context);

    return BlocBuilder<ExternalBloc, ExternalState>(
      builder: (BuildContext context, _state) {
        if (_state is NormalExternalState) {
          if(_state.notfound != null) {
            if (_state.notfound) {
              print("GO TO NEW PRODUCT");
//addProducts(_state.barcode);
            } else {
              _listProductPack.add(_state.productPack);
            }
          }
        }
        return ListView.builder(
            itemCount: _listProductPack.length ?? 0,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Single_cart_product(_listProductPack[index]),
              );
            });
      },
    );
  }
}

class Single_cart_product extends StatelessWidget {
  final ProductPack _productPack;
  String _image;

  Single_cart_product(this._productPack);

  @override
  Widget build(BuildContext context) {
    _image = _productPack.product.image != null
        ? (_productPack.product.image.length > 0 ? _productPack.product.image[0] : "")
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
                  builder: (context) => ProductDetail(_productPack.product,context),
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
                            width: 100,
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
                            width: MediaQuery.of(context).size.width -
                                100 -
                                50 -
                                100,
                            //color: Color(0x40000000),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                _productPack.product.name ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: GoogleFonts.itim(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black87),
                              ),
                            ),
                          ),
                          Container(
                            width: 90,
                            color: Colors.white,
                            child: Container(
                              child: Text(
                                "${_productPack.product.salePrice}" + " ฿" ?? "",
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
                            width: 50,
                            alignment: Alignment.centerRight,
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                new IconButton(
                                  icon: Icon(Icons.arrow_drop_up),
                                  onPressed: () {},
                                ),
                                new Text(
                                  _productPack.count.toString(),
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
