
import 'package:cloud_firestore/cloud_firestore.dart';

class TypeModel {

  static const NAME = "name";



  String name;


  TypeModel({this.name});

  TypeModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data;

    name = data[NAME];
  }

  Map<String, dynamic> toMap() {
    return {
      NAME : name,
    };
  }


}