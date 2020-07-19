import 'package:cloud_firestore/cloud_firestore.dart';

class ShopDetailModel {

  static const EMAIL = "email";
  static const NAME = "name";
  static const ADDRESS = "address";
  static const TAX = "tax";
  static const PHONE = "phone";

  String email;
  String shopName;
  String shopAddress;
  String shopTax;
  String shopNumber;

  ShopDetailModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
    email = data[EMAIL];
    shopName = data[NAME];
    shopAddress = data[ADDRESS];
    shopTax = data[TAX];
    shopNumber = data[PHONE];
  }

  ShopDetailModel.fromMap(Map<String, dynamic> data) {
    email = data[EMAIL];
    shopName = data[NAME];
    shopAddress = data[ADDRESS];
    shopTax = data[TAX];
    shopNumber = data[PHONE];
  }

  Map<String, dynamic> toMap() {
    return {
      EMAIL : email,
      NAME : shopName,
      ADDRESS : shopAddress,
      TAX : shopTax,
      PHONE : shopNumber
    };
  }

}