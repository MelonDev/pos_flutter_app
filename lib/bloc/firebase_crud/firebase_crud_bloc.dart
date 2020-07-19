import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:meta/meta.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';
import 'package:posflutterapp/models/CartModel.dart';
import 'package:posflutterapp/models/ProductPack.dart';
import 'package:posflutterapp/models/ShopDetailModel.dart';
import 'package:posflutterapp/models/TransitionItem.dart';
import 'package:posflutterapp/models/TransitionModel.dart';
import 'package:posflutterapp/models/TypeModel.dart';
import 'package:posflutterapp/models/products_models.dart';
import 'package:posflutterapp/page/receipt_page.dart';
import 'package:posflutterapp/tools/TransitionDateTimeConverter.dart';
import 'package:posflutterapp/tools/TypeTool.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

part 'firebase_crud_event.dart';

part 'firebase_crud_state.dart';

class FirebaseCrudBloc extends Bloc<FirebaseCrudEvent, FirebaseCrudState> {
  @override
  FirebaseCrudState get initialState => InitialFirebaseCrudState();

  @override
  Stream<FirebaseCrudState> mapEventToState(FirebaseCrudEvent event) async* {
    if (event is InitialFirebaseCrudEvent) {
      yield InitialFirebaseCrudState(clear: event.clear);
    } else if (event is AddProductFirebaseCrudEvent) {
      yield* _mapAddToState(event);
    } else if (event is UpdateProductFirebaseCrudEvent) {
      yield* _mapUpdateToState(event);
    } else if (event is DeleteProductFirebaseCrudEvent) {
      yield* _mapDeleteToState(event);
    } else if (event is DeleteTransitionFirebaseCrudEvent) {
      yield* _mapDeleteTransitionToState(event);
    } else if (event is AddTransitionFirebaseCrudEvent) {
      yield* _transitionToState(event);
    } else if (event is StartTransitionFirebaseCrudEvent) {
      yield* _startTransitionToState(event);
    } else if (event is AddTypeFirebaseCrudEvent) {
      yield* _mapAddTypeToState(event);
    }
  }

  @override
  Stream<FirebaseCrudState> _mapAddTypeToState(
      AddTypeFirebaseCrudEvent event) async* {
    yield LoadingFirebaseCrudState();

    if (event.id == null) {
      await _addType(event.name);
    } else {
      if (event.delete != null) {
        await _deleteType(event.id);
      } else {
        await _updateType(event.name, event.id);
      }
    }
    ExternalBloc _externalBloc = BlocProvider.of<ExternalBloc>(event.context);
    if (event.isChoose) {
      _externalBloc.add(
          ChooseTypeExternalEvent(event.context, event.isEdit, event.name));
    } else {
      _externalBloc.add(LoadTypeExternalEvent());
    }
    yield ClearFirebaseCrudState();
  }

  @override
  Stream<FirebaseCrudState> _mapAddToState(
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
      "size": event.product.size,
      "quantity": event.product.quantity,
      "createAt": DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now()),
      "updateAt": DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now())
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

    yield ClearFirebaseCrudState();
    Navigator.pop(event.context);
  }

  Future<String> addShopDetail(AddShopDetailFirebaseCrudEvent event) async{

    Map<String, dynamic> data = {
      "email": event.email,
      "name": event.shopName,
      "tax": event.shopTax,
      "address": event.shopAddress,
      "phone": event.shopNumber
    };
    String ref = 'shop';

    DocumentReference path = await _initialFirestore(ref,"detail");
    if (path != null) {
      await path.setData(data);
    }
    return null;
  }

  Future<String> _uploadImage(String id, File imageFile) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final String picture = "$id.jpg";
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user.uid != null) {
      StorageUploadTask task =
          storage.ref().child(user.uid).child(picture).putFile(imageFile);

      StorageTaskSnapshot snap = await task.onComplete;

      if (snap != null) {
        String imageUrl = await snap.ref.getDownloadURL();
        return imageUrl;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<DocumentReference> _initialFirestore(String ref, String id) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      if (id == null) {
        return Firestore.instance
            .collection("Users")
            .document(user.uid)
            .collection(ref)
            .document();
      } else {
        return Firestore.instance
            .collection("Users")
            .document(user.uid)
            .collection(ref)
            .document(id);
      }
    } else {
      return null;
    }
  }

  Future<void> _addType(String typeName) async {
    String id = Uuid().v1().toString();

    Map<String, dynamic> data = {"id": id, "name": typeName};
    DocumentReference path = await _initialFirestore("types", id);
    if (path != null) {
      await path.setData(data);
    }
  }

  Future<void> _updateType(String typeName, String id) async {
    Map<String, dynamic> data = {"id": id, "name": typeName};
    DocumentReference path = await _initialFirestore("types", id);
    if (path != null) {
      await path.updateData(data);
    }
  }

  Future<void> _deleteType(String id) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      await Firestore.instance
          .collection("Users")
          .document(user.uid)
          .collection("types")
          .document(id)
          .delete();
    }
  }

  Future<void> _createProduct(String ref, String id, Map<String, dynamic> data,
      List<String> imageList) async {
    data["images"] = imageList ?? [];

    DocumentReference path = await _initialFirestore(ref, id);
    if (path != null) {
      await path.setData(data);
    }
  }

  Future<void> _updateProduct(String ref, String id, Map<String, dynamic> data,
      List<String> imageList) async {
    data["images"] = imageList ?? [];

    DocumentReference path = await _initialFirestore(ref, id);
    if (path != null) {
      await path.updateData(data);
    }
  }

  @override
  Stream<FirebaseCrudState> _mapUpdateToState(
      UpdateProductFirebaseCrudEvent event) async* {
    yield LoadingFirebaseCrudState();

    Map<String, dynamic> data = {
      "id": event.product.id,
      "productName": event.product.name,
      "serialNumber": event.product.serialNumber,
      "type": event.product.type,
      "price": event.product.price,
      "salePrice": event.product.salePrice,
      "size": event.product.size,
      "quantity": event.product.quantity,
      "createAt": event.product.createdAt,
      "updateAt": DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now())
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
  Stream<FirebaseCrudState> _mapDeleteToState(
      DeleteProductFirebaseCrudEvent event) async* {
    yield LoadingFirebaseCrudState();
    String ref = 'products';
    final String picture = "${event.key}.jpg";

    DocumentReference documentReference;

    DocumentReference path = await _initialFirestore(ref, event.key);

    if (path != null) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      if (user.uid != null) {
        StorageReference storageReference =
            FirebaseStorage.instance.ref().child(user.uid).child(picture);
        try {
          await Firestore.instance
              .collection("Users")
              .document(user.uid)
              .collection(ref)
              .document(event.key)
              .delete();
          //await documentReference.delete();
          await storageReference.delete();
        } catch (error) {
          print(error);
        }
      }
    }

    Navigator.pop(event.context);
    yield ClearFirebaseCrudState();
  }

  @override
  Stream<FirebaseCrudState> _mapDeleteTransitionToState(
      DeleteTransitionFirebaseCrudEvent event) async* {
    yield LoadingFirebaseCrudState();
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        await Firestore.instance
            .collection("Users")
            .document(user.uid)
            .collection("transition")
            .document(event.key)
            .delete();
      }
    } catch (error) {
      print(error);
    }
    ExternalBloc _externalBloc = BlocProvider.of<ExternalBloc>(event.context);
    if (event.tabPosition == 0) {
      _externalBloc.add(NowadaysReadTransitionExternalEvent());
    } else if (event.tabPosition == 1) {
      _externalBloc.add(WeekReadTransitionExternalEvent());
    } else if (event.tabPosition == 2) {
      _externalBloc.add(MonthReadTransitionExternalEvent());
    } else if (event.tabPosition == 3) {
      _externalBloc.add(YearReadTransitionExternalEvent());
    }

    yield ClearFirebaseCrudState();
  }

  Future<List<TypeModel>> readingTypeCRUD() async {
    QuerySnapshot querySnapshot;

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      querySnapshot = await Firestore.instance
          .collection("Users")
          .document(user.uid)
          .collection('types')
          .getDocuments();
    }

    List<TypeModel> list = await querySnapshot.documents
        .map((document) => TypeModel.fromSnapshot(document))
        .toList();
    return list;
  }

  Future<ShopDetailModel> readingShopDetail() async {
    QuerySnapshot querySnapshot;

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      querySnapshot = await Firestore.instance
          .collection("Users")
          .document(user.uid)
          .collection('shop')
          .getDocuments();
    }

    return await querySnapshot.documents
        .map((document) => ShopDetailModel.fromSnapshot(document))
        .toList()[0];
  }

  Future<List<Product>> readingCRUD() async {
    QuerySnapshot querySnapshot;

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      querySnapshot = await Firestore.instance
          .collection("Users")
          .document(user.uid)
          .collection('products')
          .getDocuments();
    }

    return await querySnapshot.documents
        .map((document) => Product.fromSnapshot(document))
        .toList();
  }

  Future<List<TransitionModel>> readingTransitionCRUD() async {
    QuerySnapshot querySnapshot;

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      querySnapshot = await Firestore.instance
          .collection("Users")
          .document(user.uid)
          .collection('transition')
          .getDocuments();
    }

    List<TransitionModel> listModel = await querySnapshot.documents
        .map((document) => TransitionModel.fromSnapshot(document))
        .toList();

    return listModel;

    //return TransitionDateTimeConverter().compareTransitionItemList(listModel);
  }

  Future<List<TransitionItem>> readingNowadaysTransitionCRUD() async {
    List<TransitionModel> rawList = await readingTransitionCRUD();

    List<TransitionModel> filterList = [];

    DateTime dateTime = DateTime.now();

    for (TransitionModel model in rawList) {
      var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      DateTime modelDateTime = formatter.parse(model.createAt);

      if (modelDateTime.year == dateTime.year &&
          Jiffy().week == Jiffy(modelDateTime).week && Jiffy().day == Jiffy(modelDateTime).day) {
        filterList.add(model);
      }
    }

    return TransitionDateTimeConverter().compareTransitionItemList(filterList);
  }

  Future<List<TransitionItem>> readingWeekTransitionCRUD() async {
    List<TransitionModel> rawList = await readingTransitionCRUD();

    List<TransitionModel> filterList = [];

    DateTime dateTime = DateTime.now();

    for (TransitionModel model in rawList) {
      var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      DateTime modelDateTime = formatter.parse(model.createAt);

      if (modelDateTime.year == dateTime.year &&
          Jiffy().week == Jiffy(modelDateTime).week) {
        filterList.add(model);
      }
    }

    return TransitionDateTimeConverter().compareTransitionItemList(filterList);
  }

  Future<List<TransitionItem>> readingMonthTransitionCRUD(
      int month, int year) async {
    List<TransitionModel> rawList = await readingTransitionCRUD();

    List<TransitionModel> filterList = [];

    DateTime dateTime = DateTime.now();

    for (TransitionModel model in rawList) {
      var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      DateTime modelDateTime = formatter.parse(model.createAt);
      if (modelDateTime.year == (year ?? dateTime.year) &&
          modelDateTime.month == (month ?? dateTime.month)) {
        filterList.add(model);
      }
    }

    return TransitionDateTimeConverter().compareTransitionItemList(filterList);
  }

  Future<List<TransitionItem>> readingYearTransitionCRUD(int year) async {
    List<TransitionModel> rawList = await readingTransitionCRUD();

    List<TransitionModel> filterList = [];

    DateTime dateTime = DateTime.now();

    for (TransitionModel model in rawList) {
      var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      DateTime modelDateTime = formatter.parse(model.createAt);

      if (modelDateTime.year == (year ?? dateTime.year)) {
        filterList.add(model);
      }
    }

    return TransitionDateTimeConverter().compareTransitionItemList(filterList);
  }

  @override
  Stream<FirebaseCrudState> _transitionToState(
      AddTransitionFirebaseCrudEvent event) async* {
    yield LoadingFirebaseCrudState();
    String refTransition = 'transition';
    String refProduct = 'products';

    WriteBatch batch = Firestore.instance.batch();

    String id = Uuid().v1().toString();

    String date = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now());

    Map<String, dynamic> data = {
      "id": id,
      "price": event.price,
      "receiveMoney": event.receiveMoney,
      "cart": event.listProduct.map((i) => i.toMap()).toList(),
      "createAt": date
    };

    DocumentReference documentReference =
        await _initialFirestore(refTransition, id);
    if (documentReference != null) {
      batch.setData(documentReference, data);
    }

    for (ProductPack productPack in event.listProduct) {
      DocumentReference documentReferencePack =
          await _initialFirestore(refProduct, productPack.product.id);
      if (documentReferencePack != null) {
        Product product = productPack.product;
        product.quantity =
            (int.parse(product.quantity) - productPack.count).toString();
        batch.updateData(documentReferencePack, product.toMap());
      }
    }

    await batch.commit();

    BlocProvider.of<ExternalBloc>(event.context).add(InitialExternalEvent());

    List<CartModel> listCart = [];

    for (ProductPack pack in event.listProduct) {
      CartModel cartModel = CartModel();
      cartModel.product = pack.product;
      cartModel.amount = pack.count;
      listCart.add(cartModel);
    }

    TransitionModel transitionModel = TransitionModel();
    transitionModel.id = id;
    transitionModel.cart = listCart;
    transitionModel.price = event.price.toStringAsFixed(2);
    transitionModel.receiveMoney = event.receiveMoney.toStringAsFixed(2);
    transitionModel.createAt = date;

    ShopDetailModel shopDetailModel = await this.readingShopDetail();

    _showDialogAfterPay(event.context, TransitionItem(transitionModel, null),shopDetailModel);

    //_showDialogSuccess(event.context, event.receiveMoney - event.price);

    yield ClearFirebaseCrudState();
  }

  @override
  Stream<FirebaseCrudState> _startTransitionToState(
      StartTransitionFirebaseCrudEvent event) async* {
    _showDialogPay(event.context, event.price, event.listProduct);
    yield ClearFirebaseCrudState();
  }

  _showDialogSuccess(BuildContext context, double change) {
    Alert(
      context: context,
      title: "เสร็จสิ้น",
      desc: "เงินทอน ${change.toStringAsFixed(2)} บาท",
      buttons: [
        DialogButton(
          child: Text(
            "ยกเลิก",
            style: GoogleFonts.itim(color: Colors.black87),
          ),
          color: Colors.black12,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text("ยืนยัน"),
          color: Colors.green,
          onPressed: () {
            BlocProvider.of<ExternalBloc>(context).add(InitialExternalEvent());
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    ).show();
  }

  _showDialogConfirm(BuildContext context, List<ProductPack> listProduct,
      double price, double receiveMoney) {
    Alert(
      context: context,
      title: "ยืนยันการชำระเงิน",
      desc: "เงินทอน ${(receiveMoney - price).toStringAsFixed(2)} บาท",
      buttons: [
        DialogButton(
          child: Text(
            "ยกเลิก",
            style: GoogleFonts.itim(color: Colors.black87),
          ),
          color: Colors.black12,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text("ชำระเงิน"),
          color: Colors.green,
          onPressed: () {
            Navigator.pop(context);
            this.add(AddTransitionFirebaseCrudEvent(
                listProduct, price, receiveMoney, context));
          },
        ),
      ],
    ).show();
  }

  _showDialogNotEnoughMoney(BuildContext context) {
    Alert(
      context: context,
      title: "ยอดเงินไม่เพียงพอ",
      //desc: "เงินทอน ${change.toStringAsFixed(2)} บาท",
      buttons: [
        DialogButton(
          child: Text("ยืนยัน"),
          color: Colors.green,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ).show();
  }

  _showDialogPay(
      BuildContext context, double _totalPrice, List<ProductPack> listProduct) {
    TextEditingController _reciveMoneyController = TextEditingController();
    Alert(
      context: context,
      title: "ชำระเงิน",
      desc: "ยอดรวม ${_totalPrice.toStringAsFixed(2)} บาท",
      content: Form(
        child: Column(
          children: [
            TextFormField(
              controller: _reciveMoneyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "ระบุจำนวนเงิน"),
            ),
          ],
        ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "ยกเลิก",
            style: GoogleFonts.itim(color: Colors.black87),
          ),
          color: Colors.black12,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text(
            "ยืนยัน",
            style: GoogleFonts.itim(color: Colors.black87),
          ),
          color: Colors.green,
          onPressed: () {
            try {
              if (double.parse(_reciveMoneyController.text) >= _totalPrice) {
                Navigator.pop(context);

                /*   this.add(AddTransitionFirebaseCrudEvent(
                    listProduct,
                    _totalPrice,
                    double.parse(_reciveMoneyController.text),
                    context));


              */
                _showDialogConfirm(context, listProduct, _totalPrice,
                    double.parse(_reciveMoneyController.text));
              } else {
                Navigator.pop(context);
                _showDialogNotEnoughMoney(context);
              }
            } catch (error) {
              Navigator.pop(context);

              print("NOT DOUBLE");
            }
          },
        ),
      ],
    ).show();
  }

  _showDialogAfterPay(BuildContext context, TransitionItem item,ShopDetailModel shopDetailModel) {
    Alert(
      context: context,
      title: "บันทึกเรียบร้อย",
      //desc: "เงินทอน ${change.toStringAsFixed(2)} บาท",
      buttons: [
        DialogButton(
          child: Text("ดูใบเสร็จ"),
          color: Colors.black12,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new ReceiptPage(item,shopDetailModel),
                ));
          },
        ),
        DialogButton(
          child: Text("ปิด"),
          color: Colors.green,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    ).show();
  }
}
