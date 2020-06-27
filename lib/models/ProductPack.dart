import 'package:posflutterapp/models/products_models.dart';

class ProductPack{

  Product product;
  int count;

  ProductPack initialProductPack(Product product){
    this.product = product;
    this.count = 1;
    return this;
  }

  void increaseCount(){
    this.count += 1;
  }

  void decreaseCount(){
    this.count -= 1;
  }

}