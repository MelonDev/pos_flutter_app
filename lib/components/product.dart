import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posflutterapp/bloc/firebase_products/firebase_products_bloc.dart';
import 'package:posflutterapp/page/page_products_details.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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
          return GridView.builder(
              itemCount: _state.data.length ?? 0,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Single_prod(
                    prod_name: _state.data[index].name,
                    prod_image: _state.data[index].images != null
                        ? (_state.data[index].images.length > 0
                            ? _state.data[index].images[0]
                            : "")
                        : "",
                    prod_quantity: _state.data[index].salePrice,
                    prod_price: _state.data[index].quantity,
                    prod_type: _state.data[index].type,
                    prod_salePrice: _state.data[index].salePrice,
                    prod_serialNumber: _state.data[index].serialNumber,
                    prod_size: _state.data[index].sizes,
                  ),
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

class Single_prod extends StatelessWidget {
  final prod_name;
  final String prod_image;
  final prod_quantity;
  final prod_price;
  final prod_salePrice;
  final prod_serialNumber;
  final prod_size;
  final prod_type;

  Single_prod({
    this.prod_name,
    this.prod_image,
    this.prod_quantity,
    this.prod_price,
    this.prod_salePrice,
    this.prod_serialNumber,
    this.prod_size,
    this.prod_type,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: new Text("hero1"),
        child: Material(
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) => new ProductDetail(
                  product_detail_name: prod_name,
                  product_detail_price: prod_price,
                  product_detail_quantity: prod_quantity,
                  product_detail_image: prod_image,
                  product_detail_size: prod_size,
                  product_detail_salePrice: prod_salePrice,
                  product_detail_serialNumber: prod_serialNumber,
                  product_detail_type: prod_type,
                ),
              ),
            ),
            child: GridTile(
              footer: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: Text(
                    prod_name ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: Text(
                    "ราคา " + "$prod_price" + " ฿" ?? "",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    "คงเหลือ " + "$prod_quantity" ?? "",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              child: prod_image.length > 0
                  ? Image.network(
                      prod_image,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }
}
