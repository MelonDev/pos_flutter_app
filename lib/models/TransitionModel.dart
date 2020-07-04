

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:posflutterapp/models/CartModel.dart';
import 'package:posflutterapp/models/products_models.dart';

class TransitionModel {

  static const CART = "cart";
  static const CREATEAT = "createAt";
  static const ID = "id";
  static const PRICE = "price";
  static const RECEIVEMONEY = "receiveMoney";


  List<CartModel> cart;
  String createAt;
  String id;
  String price;
  String receiveMoney;

  TransitionModel();

  TransitionModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
    cart = _convertToListCart(data[CART]);
    createAt = data[CREATEAT];
    id = data[ID];
    price =double.parse(data[PRICE].toString()).toStringAsFixed(2);
    receiveMoney = double.parse(data[RECEIVEMONEY].toString()).toStringAsFixed(2);
  }

  Map<String, dynamic> toMap() {
    return {
      ID : id,
      CART: cart,
      CREATEAT : createAt,
      PRICE : price,
      RECEIVEMONEY : receiveMoney,
    };
  }

  List<CartModel> _convertToListCart(List<dynamic> list){
    return list.map((value) => CartModel.fromMap(value)).toList();
  }


}