part of 'firebase_products_bloc.dart';

@immutable
abstract class FirebaseProductsEvent {}

class StartFirebaseProductsEvent extends FirebaseProductsEvent {
  StartFirebaseProductsEvent();
}

class RefreshFirebaseProductsEvent extends FirebaseProductsEvent {
  final QuerySnapshot snapshot;

  RefreshFirebaseProductsEvent(this.snapshot);
}

class InitialFirebaseProductsEvent extends FirebaseProductsEvent {
  InitialFirebaseProductsEvent();
}
