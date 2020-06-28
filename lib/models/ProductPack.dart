import 'package:posflutterapp/models/products_models.dart';

class ProductPack{

  Product product;
  int count;

  ProductPack initialProductPack(Product product){
    this.product = product;
    this.count = 1;
    return this;
  }

  ProductPack increaseCount(){
    this.count += 1;
    return this;
  }

  ProductPack decreaseCount(){
    this.count -= 1;
    return this;
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'amount': count
    };
  }



}