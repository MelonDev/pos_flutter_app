import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';
import 'package:posflutterapp/bloc/firebase_products/firebase_products_bloc.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
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

    return BlocBuilder<FirebaseProductsBloc, FirebaseProductsState>(
      builder: (BuildContext context, _state) {
        print("HI");
        print(_state);
        if (_state is UpdatedFirebaseProductsState) {
          return PageView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return ProductDetail(
                  product_detail_name: _state.data[index].name,
                  product_detail_image: _state.data[index].images != null
                      ? (_state.data[index].images.length > 0
                          ? _state.data[index].images[0]
                          : "")
                      : "",
                  product_detail_quantity: _state.data[index].salePrice,
                  product_detail_price: _state.data[index].quantity,
                  product_detail_type: _state.data[index].type,
                  product_detail_salePrice: _state.data[index].salePrice,
                  product_detail_serialNumber: _state.data[index].serialNumber,
                  product_detail_size: _state.data[index].sizes,
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

class ProductDetail extends StatelessWidget {
  final product_detail_name;
  final String product_detail_image;
  final product_detail_quantity;
  final product_detail_price;
  final product_detail_salePrice;
  final product_detail_serialNumber;
  final product_detail_size;
  final product_detail_type;

  ProductDetail({
    this.product_detail_name,
    this.product_detail_image,
    this.product_detail_quantity,
    this.product_detail_price,
    this.product_detail_salePrice,
    this.product_detail_serialNumber,
    this.product_detail_size,
    this.product_detail_type,
  });

  ExternalBloc _externalBloc;

  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _serialNumberTextController = TextEditingController();
  TextEditingController _typeTextController = TextEditingController();
  TextEditingController _sizeTextController = TextEditingController();
  TextEditingController _priceTextController = TextEditingController();
  TextEditingController _salePriceTextController = TextEditingController();
  TextEditingController _quantityTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.purple),
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Text(
          product_detail_name ?? "",
          style: TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () {}
//            => Navigator.push(
//              context,
//              new MaterialPageRoute(
//                builder: (context) => new ScannerPage(),
//              ),)
            ,
            child: Icon(
              Icons.edit,
              color: Colors.purple,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: BlocBuilder<ExternalBloc, ExternalState>(
                  builder: (BuildContext context, _state) {
                    print("HI");
                    print(_state);
                    if (_state is NormalExternalState) {
                      _serialNumberTextController.text = _state.barcode ?? "";
                      return ListView(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 100, right: 100),
                            child: OutlineButton(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.8),
                                  width: 1.0),
                              child: product_detail_image.length > 0
                                  ? Image.network(
                                      product_detail_image,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(),
                            ),
                          ),

//                    Positioned(
//                      bottom: 0,
//                      child: Container(
//                        width: MediaQuery.of(context).size.width,
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Padding(
//                              padding: const EdgeInsets.all(10.0),
//                              child: Text(
//                                'Product Blazer',
//                                style: TextStyle(
//                                    color: Colors.purple,
//                                    fontWeight: FontWeight.w300,
//                                    fontSize: 20),
//                              ),
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.all(10.0),
//                              child: Text(
//                                '\$35.99',
//                                textAlign: TextAlign.end,
//                                style: TextStyle(
//                                    color: Colors.purple,
//                                    fontSize: 26,
//                                    fontWeight: FontWeight.bold),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  enabled: false,
                                  controller: _nameTextController,
                                  decoration: InputDecoration(
                                      hintText: product_detail_name,
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'The Name field cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  enabled: false,
                                  controller: _serialNumberTextController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    hintText: product_detail_serialNumber,
                                    border: InputBorder.none,
//                                    prefixIcon: IconButton(
//                                      icon: Icon(
//                                        Icons.camera,
//                                      ),
//                                      tooltip: "Scan",
//                                      onPressed: () {
//                                        print("A0");
//                                        _externalBloc
//                                            .add(OpenScannerExternalEvent());
//                                      },
//                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'The SerialNumber field cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  enabled: false,
                                  controller: _typeTextController,
                                  decoration: InputDecoration(
                                    hintText: product_detail_type,
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'The Type field cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  enabled: false,
                                  controller: _sizeTextController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      hintText: product_detail_size,
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'The Size field cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  enabled: false,
                                  controller: _priceTextController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      hintText: product_detail_price,
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'The Price field cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  enabled: false,
                                  controller: _salePriceTextController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      hintText: product_detail_salePrice,
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'The Price field cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  enabled: false,
                                  controller: _quantityTextController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      hintText: product_detail_quantity,
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'The Quantity field cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(9),
                            child: Material(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.orange,
                                elevation: 0.0,
                                child: MaterialButton(
                                  onPressed: () {},
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Buy now",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                )),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        color: Colors.red,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
