
import 'package:cloud_firestore/cloud_firestore.dart';

class TypeModel {

  static const ID = "id";
  static const NAME = "name";



  String name;
  String id;


  TypeModel({this.name});

  TypeModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
id = data[ID];
    name = data[NAME];

  }

  Map<String, dynamic> toMap() {
    return {
      ID : id,
      NAME : name,
    };
  }


}