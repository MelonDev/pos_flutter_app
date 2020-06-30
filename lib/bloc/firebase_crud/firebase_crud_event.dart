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