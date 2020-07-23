import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  static const ID = "id";
  static const TYPE = "type";
  static const NAME = "productName";
//  static const PRICE = "price";
  static const SERIALNUMBER = "serialNumber";
  static const QUANTITY = "quantity";
  static const SIZES = "size";
  static const SALEPRICE = "salePrice";
  static const IMAGES = "images";
  static const CREATEDAT = "createAt";
  static const UPDATEDAT = "updateAt";
  static const SUBINGREDIENTS = "subIngredients";

  String id;
  String name;
  String type;
  List<String> image;
  String serialNumber;
//  String price;
  String quantity;
  String size;
  List subIngredients;
  String salePrice;
  String createdAt;
  String updatedAt;

  Product();

  Product.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
    name = data[NAME];
    id = data[ID];
    type = data[TYPE];
//    price = double.parse(data[PRICE].toString()).toStringAsFixed(2);
    quantity = data[QUANTITY].toString();
    salePrice = double.parse(data[SALEPRICE].toString()).toStringAsFixed(2);
    serialNumber = double.parse(data[SERIALNUMBER].toString()).toStringAsFixed(0);
    size = data[SIZES].toString();
    subIngredients = data[SUBINGREDIENTS];
//    image = data[IMAGES];
    image = _convertToListString(data[IMAGES]);
    createdAt = data[CREATEDAT];
    updatedAt = data[UPDATEDAT];
  }

  List<String> _convertToListString(List<dynamic> list){
    return list.map((value) => value.toString()).toList();
  }

  Product.fromMap(Map<String, dynamic> data) {
    name = data[NAME];
    id = data[ID];
    type = data[TYPE];
//    price = double.parse(data[PRICE].toString()).toStringAsFixed(2);
    quantity = data[QUANTITY].toString();
    salePrice = double.parse(data[SALEPRICE].toString()).toStringAsFixed(2);
    serialNumber = double.parse(data[SERIALNUMBER].toString()).toStringAsFixed(0);
    size = data[SIZES].toString();
    subIngredients = data[SUBINGREDIENTS];
    image = _convertToListString(data[IMAGES]);
    createdAt = data[CREATEDAT];
    updatedAt = data[UPDATEDAT];
  }



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': name,
      'type': type,
//      'price': price,
      'serialNumber': serialNumber,
      'quantity': quantity,
      'size': size,
      'salePrice': salePrice,
      'images': image,
      'createAt': createdAt,
      'updateAt':updatedAt
    };
  }
}
