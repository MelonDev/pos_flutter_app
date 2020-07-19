part of 'firebase_crud_bloc.dart';

@immutable
abstract class FirebaseCrudEvent {}

class InitialFirebaseCrudEvent extends FirebaseCrudEvent {
  final bool clear;
  InitialFirebaseCrudEvent({this.clear});
}

class AddProductFirebaseCrudEvent extends FirebaseCrudEvent {
  final Product product;
  final File imageFile;
  final BuildContext context;

  AddProductFirebaseCrudEvent(this.context,this.product, this.imageFile);



}

class AddTransitionFirebaseCrudEvent extends FirebaseCrudEvent {
  final List<ProductPack> listProduct;
  final double price;
  final double receiveMoney;
  final BuildContext context;

  AddTransitionFirebaseCrudEvent(this.listProduct, this.price, this.receiveMoney, this.context);


}

class StartTransitionFirebaseCrudEvent extends FirebaseCrudEvent {
  final List<ProductPack> listProduct;
  final double price;
  final BuildContext context;

  StartTransitionFirebaseCrudEvent(this.listProduct, this.price, this.context);


}


class UpdateProductFirebaseCrudEvent extends FirebaseCrudEvent {
  final Product product;
  final File imageFile;
  final BuildContext context;
  final bool isImageUpdate;


  UpdateProductFirebaseCrudEvent(this.context,this.product, this.imageFile,this.isImageUpdate);
}

class DeleteProductFirebaseCrudEvent extends FirebaseCrudEvent {

  final BuildContext context;
  final String key;


  DeleteProductFirebaseCrudEvent(this.context,this.key);
}

class DeleteTransitionFirebaseCrudEvent extends FirebaseCrudEvent {

  final BuildContext context;
  final String key;
  final int tabPosition;


  DeleteTransitionFirebaseCrudEvent(this.context,this.key,this.tabPosition);
}

class AddTypeFirebaseCrudEvent extends FirebaseCrudEvent {

  final BuildContext context;
  final String name;
  final String id;
  final bool isChoose;
  final bool isEdit;
  final bool delete;

  AddTypeFirebaseCrudEvent(this.context,this.isChoose, this.name,this.isEdit,{this.id,this.delete});

}

class AddShopDetailFirebaseCrudEvent extends FirebaseCrudEvent {
  final BuildContext context;
  final String email;
  final String shopName;
  final String shopAddress;
  final String shopTax;
  final String shopNumber;

  AddShopDetailFirebaseCrudEvent(this.context,this.email, this.shopName, this.shopAddress,
      this.shopTax, this.shopNumber);
}

