import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:posflutterapp/models/products_models.dart';

class CartModel {

  static const AMOUNT = "amount";
  static const PRODUCT = "product";

  int amount;
  Product product;

  CartModel();

  CartModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
    amount = data[AMOUNT];
    product = Product.fromMap(data[PRODUCT]);
  }

  CartModel.fromMap(Map<String, dynamic> data) {
    amount = data[AMOUNT];
    product = Product.fromMap(data[PRODUCT]);
  }

    Map<String, dynamic> toMap() {
    return {
      AMOUNT : amount,
      PRODUCT : product
    };
  }


}