import 'package:posflutterapp/models/products_models.dart';

import 'ProductPack.dart';

class ProductPackDuplicate{

  ProductPack productPack;
  int position;

  ProductPackDuplicate initialProductPack(ProductPack product,int position){

    this.productPack = product;
    this.position = position;
    return this;
  }

}