import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  Firestore _firestore = Firestore.instance;
  String ref = 'products';

  void uploadProduct(String productId,Map<String, dynamic> data) {
    data["id"] = productId;
    _firestore.collection(ref).document(productId).setData(data);
  }
}
