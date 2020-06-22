import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:posflutterapp/models/products_models.dart';
import 'package:uuid/uuid.dart';

part 'firebase_products_event.dart';

part 'firebase_products_state.dart';

class FirebaseProductsBloc
    extends Bloc<FirebaseProductsEvent, FirebaseProductsState> {
  @override
  FirebaseProductsState get initialState => InitialFirebaseProductsState();

  Firestore _firestore;

  @override
  Stream<FirebaseProductsState> mapEventToState(
      FirebaseProductsEvent event) async* {
    if (event is InitialFirebaseProductsEvent) {
      yield InitialFirebaseProductsState();
    } else if (event is RefreshFirebaseProductsEvent) {
      yield* mapRefreshToState(event);
    }
  }

  @override
  Stream<FirebaseProductsState> mapRefreshToState(
      RefreshFirebaseProductsEvent event) async* {
//    if (_firestore == null) {
//      _firestore = Firestore.instance;
//    }
//    _firestore.collection('products').snapshots().listen((value) {
//      value.documents.forEach((element) {
//        print(element.data);
//      });
//    });

//    final snapshots =
//        Firestore.instance.collection('products').getDocuments().asStream();
//    await for (final snapshot in snapshots) {
//      final snap = await snapshot.documents
//          .map((document) => Product.fromSnapshot(document))
//          .toList();
//      yield UpdatedFirebaseProductsState(snap);
//    }
    print("object");
    final snap = await event.snapshot.documents
        .map((document) => Product.fromSnapshot(document))
        .toList();
    yield UpdatedFirebaseProductsState(snap);
  }
}
