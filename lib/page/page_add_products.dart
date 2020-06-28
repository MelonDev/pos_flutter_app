import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';
import 'package:posflutterapp/bloc/firebase_crud/firebase_crud_bloc.dart';
import 'package:posflutterapp/db/product_db.dart';
import 'package:posflutterapp/models/products_models.dart';
import 'package:uuid/uuid.dart';

class addProducts extends StatefulWidget {
  final String code;

  addProducts(this.code);
  @override
  _addProductsState createState() => _addProductsState(code);
}

class _addProductsState extends State<addProducts> {
  ExternalBloc _externalBloc;
  FirebaseCrudBloc _firebaseCrudBloc;

  String code;

  _addProductsState(this.code);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GlobalKey<FormState> _categoryFormkey = GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _serialNumberTextController = TextEditingController();
  TextEditingController _typeTextController = TextEditingController();
  TextEditingController _sizeTextController = TextEditingController();
  TextEditingController _priceTextController = TextEditingController();
  TextEditingController _salePriceTextController = TextEditingController();
  TextEditingController _quantityTextController = TextEditingController();

  TextEditingController catrgoryController = TextEditingController();

  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem> categoriesDropdown = <DropdownMenuItem<String>>[];
  String _currentCategory;

//  CategoryService _categoryService = CategoryService();
  ProductService _productService = ProductService();

  File _image1;

  bool isLoading = false;

//  @override
//  void initState() {
//    _getCategories();
////    _currentCategory = categoriesDropdown[0].value;
//  }
//
//  List<DropdownMenuItem<String>> getCategoriesDropdown() {
//    List<DropdownMenuItem<String>> items = new List();
//    for (int i = 0; i < categories.length; i++) {
//      setState(() {
//        items.insert(
//            0,
//            DropdownMenuItem(
//              child: Text(categories[i].data ?? 'category'),
//              value: categories[i].data ?? 'category',
//            ));
//      });
//    }
//    print(items.length);
//    return items;
//  }

  @override
  Widget build(BuildContext context) {
    _externalBloc = BlocProvider.of<ExternalBloc>(context);
    _firebaseCrudBloc = BlocProvider.of<FirebaseCrudBloc>(context);

    if (code != null) {
      _serialNumberTextController.text = code;
    }

    return BlocBuilder<ExternalBloc, ExternalState>(
      builder: (BuildContext context, _state) {
        print("HI");
        print(_state);
        if (_state is NormalExternalState) {
          if (_state.fromImage == null) {
            _serialNumberTextController.text = _state.barcode ?? "";
          }
          return BlocBuilder<FirebaseCrudBloc, FirebaseCrudState>(
            builder: (BuildContext contextCRUD, _stateCRUD) {
              if (_stateCRUD is LoadingFirebaseCrudState) {
                return Container(
                  color: Colors.purple,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Scaffold(
                  appBar: new AppBar(
                    iconTheme: new IconThemeData(color: Colors.purple),
                    elevation: 0.1,
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
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
                                  child: LayoutBuilder(
                                      builder: (context, constraint) {
                                    return FlatButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        color: Colors.transparent,
                                        child: Icon(
                                          Icons.arrow_back,
                                          //color: Colors.black.withAlpha(150),
                                          color: Colors.purple,
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
                                  "เพิ่มสินค้า",
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.purple),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Form(
                            key: _formKey,
                            child: isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.orange),
                                  )
                                : ListView(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 100, right: 100),
                                        child: OutlineButton(
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                              width: 1.0),
                                          onPressed: () {
                                            _externalBloc.add(
                                                OpenGelleryExternalEvent(
                                                    false));
                                          },
                                          child: _displayChild(
                                              _state.fromImage ?? _image1),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          elevation: 0.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              controller: _nameTextController,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          elevation: 0.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              controller:
                                                  _serialNumberTextController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              decoration: InputDecoration(
                                                hintText: "SerialNumber",
                                                border: InputBorder.none,
                                                prefixIcon: IconButton(
                                                  icon: Icon(Icons.camera),
                                                  tooltip: "Scan",
                                                  onPressed: () {
                                                    print("A0");
                                                    _externalBloc.add(
                                                        OpenScannerExternalEvent(
                                                            false));
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
//                          Row(
//                            children: <Widget>[
//                              Padding(
//                                padding: const EdgeInsets.all(10),
//                                child: Text(
//                                  "Type: ",
//                                  style: TextStyle(color: Colors.purple),
//                                ),
//                              ),
//                              DropdownButton<String>(
//                                items: categoriesDropdown,
//                                onChanged: changeSelectedCategory,
//                                value: _currentCategory,
//                              )
//                            ],
//                          ),

                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          elevation: 0.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              controller: _typeTextController,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          elevation: 0.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              controller: _sizeTextController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          elevation: 0.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              controller: _priceTextController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          elevation: 0.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              controller:
                                                  _salePriceTextController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          elevation: 0.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              controller:
                                                  _quantityTextController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly
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
//                          Padding(
//                            padding: const EdgeInsets.all(10),
//                            child: Material(
//                              borderRadius: BorderRadius.circular(20),
//                              color: Colors.orange,
//                              elevation: 0.0,
//                              child: MaterialButton(
//                                onPressed: () {
//                                  _categoryAlert();
//                                },
//                                minWidth: MediaQuery.of(context).size.width,
//                                child: Text(
//                                  "Add Category",
//                                  textAlign: TextAlign.center,
//                                  style: TextStyle(
//                                      color: Colors.white,
//                                      fontWeight: FontWeight.bold),
//                                ),
//                              ),
//                            ),
//                          ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.orange,
                                          elevation: 0.0,
                                          child: MaterialButton(
                                            onPressed: () {
                                              //_validateAndUpload();
                                              _firebaseCrudBloc.add(
                                                  AddProductFirebaseCrudEvent(
                                                      context,
                                                      zipProduct(),
                                                      _image1));
                                              _externalBloc
                                                  .add(InitialExternalEvent());
                                            },
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                              "Add Product",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        } else {
          return Container(
            color: Colors.red,
          );
        }
      },
    );
  }

//  void _selectImage(Future<PickedFile> pickImage, int imageNumber) async {
//    PickedFile pickedFile = await pickImage;
//    File tempImg = File(pickedFile.path);
//    switch (imageNumber) {
//      case 1:
//        setState(() => _image1 = tempImg);
//        break;
//    }
//  }

  Widget _displayChild(File _image) {
    _image1 = _image;
    if (_image == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 70, 14, 70),
        child: new Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Image.file(
        _image,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Product zipProduct() {
    Product product = Product();
    product.name = _nameTextController.text;
    product.serialNumber = _serialNumberTextController.text;
    product.type = _typeTextController.text;
    product.price = _priceTextController.text;
    product.salePrice = _salePriceTextController.text;
    product.sizes = _sizeTextController.text;
    product.quantity = _quantityTextController.text;
    return product;
  }

//  void _validateAndUpload() async {
//    if (_formKey.currentState.validate()) {
//      setState(() => isLoading = true);
//      if (_image1 != null) {
//        String imageUrl;
//        String id = Uuid().v1().toString();
//
//        final FirebaseStorage storage = FirebaseStorage.instance;
//        final String picture =
//            "$id.jpg";
//        StorageUploadTask task = storage.ref().child(picture).putFile(_image1);
//
//        task.onComplete.then((snapshot) async {
//          imageUrl = await snapshot.ref.getDownloadURL();
//          List<String> imageList = [imageUrl];
//          _productService.uploadProduct(id,{
//            "productName": _nameTextController.text,
//            "serialNumber": double.parse(_serialNumberTextController.text),
//            "type": _typeTextController.text,
//            "price": double.parse(_priceTextController.text),
//            "salePrice": double.parse(_salePriceTextController.text),
//            "size": double.parse(_sizeTextController.text),
//            "quantity": int.parse(_quantityTextController.text),
//            "images": imageList,
//          });
//          _formKey.currentState.reset();
//          setState(() => isLoading = false);
//          Fluttertoast.showToast(msg: 'Product added');
//          Navigator.pop(context);
//        });
//      } else {
//        setState(() => isLoading = false);
//        Fluttertoast.showToast(msg: 'The image must be provider');
//      }
//    }
//  }

//  _getCategories() async {
//    List<DocumentSnapshot> data = await _categoryService.getCategories();
//    print(data.length);
//    setState(() {
//      categories = data;
//      categoriesDropdown = getCategoriesDropdown();
//      _currentCategory = categories[0].data['category'];
//    });
//  }
//
//  changeSelectedCategory(String selectedCategory) {
//    setState(() => _currentCategory = selectedCategory);
//  }
}
