import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posflutterapp/bloc/firebase_products/firebase_products_bloc.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  FirebaseProductsBloc _firebaseProductsBloc;

  @override
  Widget build(BuildContext context) {
    _firebaseProductsBloc = BlocProvider.of<FirebaseProductsBloc>(context);
    _firebaseProductsBloc.add(RefreshFirebaseProductsEvent());
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

  Single_prod({
    this.prod_name,
    this.prod_image,
    this.prod_quantity,
    this.prod_price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: new Text("hero1"),
        child: Material(
          child: InkWell(
            onTap: () {},
            child: GridTile(
              footer: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: Text(
                    prod_name ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: Text(
                    "\$$prod_price" ?? "",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    "\$$prod_quantity" ?? "",
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.lineThrough),
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
