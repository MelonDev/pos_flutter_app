import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta/meta.dart';
import 'package:posflutterapp/models/products_models.dart';
import 'package:uuid/uuid.dart';

part 'firebase_crud_event.dart';

part 'firebase_crud_state.dart';

class FirebaseCrudBloc extends Bloc<FirebaseCrudEvent, FirebaseCrudState> {
  @override
  FirebaseCrudState get initialState => InitialFirebaseCrudState();

  @override
  Stream<FirebaseCrudState> mapEventToState(FirebaseCrudEvent event) async* {
    if (event is InitialFirebaseCrudEvent) {
      yield InitialFirebaseCrudState();
    } else if (event is AddProductFirebaseCrudEvent) {
      yield* mapAddToState(event);
    } else if (event is UpdateProductFirebaseCrudEvent) {
      yield* mapUpdateToState(event);
    } else if (event is DeleteProductFirebaseCrudEvent) {
      yield* mapDeleteToState(event);
    }
  }

  @override
  Stream<FirebaseCrudState> mapAddToState(
      AddProductFirebaseCrudEvent event) async* {
    yield LoadingFirebaseCrudState();
    String imageUrl;
    String id = Uuid().v1().toString();

    Map<String, dynamic> data = {
      "id": id,
      "productName": event.product.name,
      "serialNumber": event.product.serialNumber,
      "type": event.product.type,
      "price": event.product.price,
      "salePrice": event.product.salePrice,
      "size": event.product.sizes,
      "quantity": event.product.quantity,
    };
    String ref = 'products';

    if (event.imageFile != null) {
      String image = await _uploadImage(id, event.imageFile);
      if (image != null) {
        List<String> imageList = [image];
        await _createProduct(ref, id, data, imageList);
      } else {
        await _createProduct(ref, id, data, null);
      }
    } else {
      await _createProduct(ref, id, data, null);
    }

//    final FirebaseStorage storage = FirebaseStorage.instance;
//    final String picture =
//        "$id.jpg";
//    StorageUploadTask task = storage.ref().child(picture).putFile(event.imageFile);
//
//
//    await task.onComplete.then((snapshot) async {
//      imageUrl = await snapshot.ref.getDownloadURL();
//      List<String> imageList = [imageUrl];
//      Map<String, dynamic> data = {
//        "productName":event.product.name,
//        "serialNumber": event.product.serialNumber,
//        "type": event.product.type,
//        "price": event.product.price,
//        "salePrice": event.product.salePrice,
//        "size": event.product.sizes,
//        "quantity": event.product.quantity,
//        "images": imageList,
//      };
//      await Firestore.instance.collection(ref).document(id).setData(data);
//    });
    yield ClearFirebaseCrudState();
    Navigator.pop(event.context);
  }

  Future<String> _uploadImage(String id, File imageFile) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final String picture = "$id.jpg";
    StorageUploadTask task = storage.ref().child(picture).putFile(imageFile);

    StorageTaskSnapshot snap = await task.onComplete;

    if (snap != null) {
      String imageUrl = await snap.ref.getDownloadURL();
      return imageUrl;
    } else {
      return null;
    }
  }

  Future<void> _createProduct(String ref, String id, Map<String, dynamic> data,
      List<String> imageList) async {
    data["images"] = imageList ?? [];

    await Firestore.instance.collection(ref).document(id).setData(data);
  }

  Future<void> _updateProduct(String ref, String id, Map<String, dynamic> data,
      List<String> imageList) async {
    data["images"] = imageList ?? [];

    await Firestore.instance.collection(ref).document(id).updateData(data);
  }

  @override
  Stream<FirebaseCrudState> mapUpdateToState(
      UpdateProductFirebaseCrudEvent event) async* {
    yield LoadingFirebaseCrudState();

    Map<String, dynamic> data = {
      "id": event.product.id,
      "productName": event.product.name,
      "serialNumber": event.product.serialNumber,
      "type": event.product.type,
      "price": event.product.price,
      "salePrice": event.product.salePrice,
      "size": event.product.sizes,
      "quantity": event.product.quantity,
    };
    String ref = 'products';

    if (event.imageFile != null) {
      String image = await _uploadImage(event.product.id, event.imageFile);
      if (image != null) {
        List<String> imageList = [image];
        await _updateProduct(ref, event.product.id, data, imageList);
      } else {
        await _updateProduct(ref, event.product.id, data, null);
      }
    } else {
      print("isImageUpdate ${event.isImageUpdate}");
      print("NULL? ${event.product.image == null}");
      print("SIZE ${event.product.image.length}");
      if (event.isImageUpdate) {
        data["images"] = [];
      } else {
        data["images"] = event.product.image;
      }
      await _updateProduct(ref, event.product.id, data,
          event.isImageUpdate ? [] : event.product.image);
    }

    Navigator.pop(event.context);
    yield ClearFirebaseCrudState();
  }

  @override
  Stream<FirebaseCrudState> mapDeleteToState(
      DeleteProductFirebaseCrudEvent event) async* {
    yield LoadingFirebaseCrudState();
    String ref = 'products';
    final String picture = "${event.key}.jpg";

    DocumentReference documentReference =
        Firestore.instance.collection(ref).document(event.key);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(picture);
    await storageReference.delete();
    await documentReference.delete();

    Navigator.pop(event.context);
    yield ClearFirebaseCrudState();
  }

  Future<List<Product>> readingCRUD() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection('products').getDocuments();
    return await querySnapshot.documents
        .map((document) => Product.fromSnapshot(document))
        .toList();
  }
}
