part of 'firebase_crud_bloc.dart';

@immutable
abstract class FirebaseCrudEvent {}

class InitialFirebaseCrudEvent extends FirebaseCrudEvent {
  InitialFirebaseCrudEvent();
}

class AddProductFirebaseCrudEvent extends FirebaseCrudEvent {
  final Product product;
  final File imageFile;
  final BuildContext context;

  AddProductFirebaseCrudEvent(this.context,this.product, this.imageFile);



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