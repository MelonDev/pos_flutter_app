part of 'firebase_products_bloc.dart';

@immutable
abstract class FirebaseProductsState {}

class InitialFirebaseProductsState extends FirebaseProductsState {}

class UpdatedFirebaseProductsState extends FirebaseProductsState {
  final List<Product> data;

  UpdatedFirebaseProductsState(this.data);
}
