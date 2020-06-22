part of 'firebase_products_bloc.dart';

@immutable
abstract class FirebaseProductsEvent {}

class StartFirebaseProductsEvent extends FirebaseProductsEvent {
  StartFirebaseProductsEvent();
}

class RefreshFirebaseProductsEvent extends FirebaseProductsEvent {
  RefreshFirebaseProductsEvent();
}

class InitialFirebaseProductsEvent extends FirebaseProductsEvent {
  InitialFirebaseProductsEvent();
}
