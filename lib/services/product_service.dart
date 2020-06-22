import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:posflutterapp/models/products_models.dart';

class ProductsServices {
  String collection = "products";
  Firestore _firestore = Firestore.instance;

  Future<List<Product>> getProducts() async =>
      _firestore.collection(collection).getDocuments().then(
        (result) {
          List<Product> productsList = [];
          print("=== RESULT SIZE ${result.documents.length}");
          for (DocumentSnapshot item in result.documents) {
            productsList.add(Product.fromSnapshot(item));
            print(" PRODUCTSSSS ${productsList.length}");
          }
          return productsList;
        },
      );
}
