import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';
import 'package:posflutterapp/bloc/firebase_products/firebase_products_bloc.dart';
import 'package:posflutterapp/models/products_models.dart';
import 'package:posflutterapp/page/page_edit_products_details.dart';

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
                return ProductDetail(_state.data[index]);
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
  Product _product;

  Product _productBackup;

  String _image;
  File _imageOffline;

  ProductDetail(this._product);

  ExternalBloc _externalBloc;

  TextEditingController _nameTextControllerProductDetails =
      TextEditingController();
  TextEditingController _serialNumberTextControllerProductDetails =
      TextEditingController();
  TextEditingController _typeTextControllerProductDetails =
      TextEditingController();
  TextEditingController _sizeTextControllerProductDetails =
      TextEditingController();
  TextEditingController _priceTextControllerProductDetails =
      TextEditingController();
  TextEditingController _salePriceTextControllerProductDetails =
      TextEditingController();
  TextEditingController _quantityTextControllerProductDetails =
      TextEditingController();

  void updateController() {
    if (_product != null) {
      _nameTextControllerProductDetails.text = _product.name ?? "";
      _serialNumberTextControllerProductDetails.text =
          _product.serialNumber ?? "";
      _typeTextControllerProductDetails.text = _product.type ?? "";
      _sizeTextControllerProductDetails.text = _product.sizes ?? "";
      _priceTextControllerProductDetails.text = _product.price ?? "";
      _salePriceTextControllerProductDetails.text = _product.salePrice ?? "";
      _quantityTextControllerProductDetails.text = _product.quantity ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    _image = _product.images != null
        ? (_product.images.length > 0 ? _product.images[0] : "")
        : "";

    updateController();
    _externalBloc = BlocProvider.of<ExternalBloc>(context);

    return BlocBuilder<ExternalBloc, ExternalState>(
      builder: (BuildContext context, _state) {
        print("HI");
        print(_state);
        if (_state is NormalExternalState) {
          //_serialNumberTextControllerProductDetails.text = _state.barcode ?? "";

          if (_state is EditExternalState) {
            if (_state.barcode != null && _state.fromScanner != null) {
              _serialNumberTextControllerProductDetails.text =
                  _state.barcode ?? "";
            } else if (_state.fromImage != null) {
              _imageOffline = _state.fromImage;
            } else {
              _productBackup = _product;
              updateController();
            }
          } else {
            _imageOffline = null;
            if (_state.newProduct == null && _productBackup != null) {
              _product = _productBackup;
              _productBackup = null;
              updateController();
            } else if (_state.newProduct != null) {
              //_product = _state.newProduct;
              updateController();
            }
          }

          return Scaffold(
            appBar: new AppBar(
              iconTheme: new IconThemeData(color: Colors.purple),
              elevation: 0.1,
              titleSpacing: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor:
                  _state is EditExternalState ? Colors.purple : Colors.white,
              title: Stack(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                          color: Colors.transparent,
                          child: SizedBox(
                            width: 60,
                            height: 56,
                            child:
                                LayoutBuilder(builder: (context, constraint) {
                              return FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    if (_state is EditExternalState) {
                                      _externalBloc.add(
                                          BackToNormalStateExternalEvent(
                                              _state.barcode));
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  color: Colors.transparent,
                                  child: Icon(
                                    _state is EditExternalState
                                        ? Icons.close
                                        : Icons.arrow_back,
                                    size: constraint.biggest.height - 26,
                                    //color: Colors.black.withAlpha(150),
                                    color: _state is EditExternalState
                                        ? Colors.white
                                        : Colors.purple,
                                  ));
                            }),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 56,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(
                            _state is EditExternalState
                                ? "แก้ไข"
                                : "รายละเอียด",
                            style: GoogleFonts.itim(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: _state is EditExternalState
                                    ? Colors.white
                                    : Colors.purple),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          if (_state is EditExternalState) {
                            print("Start UPDATE");
                          } else {
                            _externalBloc
                                .add(EditExternalEvent(_state.barcode));
                          }
                        },
                        child: Icon(
                          _state is EditExternalState ? Icons.send : Icons.edit,
                          color: _state is EditExternalState
                              ? Colors.white
                              : Colors.purple,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            body: SafeArea(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 100, right: 100),
                            child: OutlineButton(
                              onPressed: () {
                                if (_state is EditExternalState) {
                                  _externalBloc
                                      .add(OpenGelleryExternalEvent(true));
                                }
                              },
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.8),
                                  width: 1.0),
                              child: _imageOffline != null
                                  ? Image.file(
                                      _imageOffline,
                                      fit: BoxFit.cover,
                                    )
                                  : (_image.length > 0
                                      ? Image.network(
                                          _image,
                                          fit: BoxFit.cover,
                                        )
                                      : Container()),
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
                                  enabled: _state is EditExternalState,
                                  controller: _nameTextControllerProductDetails,
                                  decoration: InputDecoration(
                                      hintText: "Name",
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
                                  enabled: _state is EditExternalState,
                                  controller:
                                      _serialNumberTextControllerProductDetails,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "SerialNumber",
                                    border: InputBorder.none,
                                    prefixIcon: IconButton(
                                      icon: Icon(
                                        Icons.camera,
                                      ),
                                      tooltip: "Scan",
                                      onPressed: () {
                                        print("A0");
                                        _externalBloc.add(
                                            OpenScannerExternalEvent(true));
                                      },
                                    ),
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
                                  enabled: _state is EditExternalState,
                                  controller: _typeTextControllerProductDetails,
                                  decoration: InputDecoration(
                                    hintText: "Type",
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
                                  enabled: _state is EditExternalState,
                                  controller: _sizeTextControllerProductDetails,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      hintText: "Size",
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
                                  enabled: _state is EditExternalState,
                                  controller:
                                      _priceTextControllerProductDetails,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      hintText: "Price",
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
                                  enabled: _state is EditExternalState,
                                  controller:
                                      _salePriceTextControllerProductDetails,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      hintText: "Sale Price",
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
                                  enabled: _state is EditExternalState,
                                  controller:
                                      _quantityTextControllerProductDetails,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      hintText: "Quantity",
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container(
            color: Colors.red,
          );
        }
      },
    );
  }
}