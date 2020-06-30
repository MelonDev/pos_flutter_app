import 'dart:async';
import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:posflutterapp/bloc/firebase_crud/firebase_crud_bloc.dart';
import 'package:posflutterapp/models/ProductPack.dart';
import 'package:posflutterapp/models/products_models.dart';
import 'package:posflutterapp/page/page_add_products.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

part 'external_event.dart';

part 'external_state.dart';

class ExternalBloc extends Bloc<ExternalEvent, ExternalState> {
  @override
  ExternalState get initialState => InitialExternalState();

  @override
  Stream<ExternalState> mapEventToState(ExternalEvent event) async* {
    if (event is InitialExternalEvent) {
      yield NormalExternalState(null);
    } else if (event is OpenScannerExternalEvent) {
      yield* _mapScannerToState(event);
    } else if (event is EditExternalEvent) {
      yield EditExternalState(event.barcode);
    } else if (event is BackToNormalStateExternalEvent) {
      yield NormalExternalState(event.barcode);
    } else if (event is OpenGelleryExternalEvent) {
      yield* _mapGelleryToState(event);
    } else if (event is OpenScannerOnCartExternalEvent) {
      yield* _mapScannerOnCartToState(event);
    } else if (event is IncreaseProductPackExternalEvent) {
      yield* _increaserProductPackToState(event);
    } else if (event is DecreaseProductPackExternalEvent) {
      yield* _decreaseProductPackToState(event);
    }else if(event is OpenImageSourceExternalEvent){
      yield* _mapImageSourceToState(event);
    }
  }

  @override
  Stream<ExternalState> _mapImageSourceToState(
      OpenImageSourceExternalEvent event) async* {
    showDialog(
        context:event.context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: double.maxFinite,
              height:100,
              child: ListView(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        this.add(OpenGelleryExternalEvent(event.context, event.isEdit,camera: true));
Navigator.pop(event.context);
                      },
                      child: ListTile(
                        title: Text("กล้อง"),
                        leading: Icon(Icons.camera),
                      ),
                    ), InkWell(
                      onTap: () {
                        this.add(OpenGelleryExternalEvent(event.context, event.isEdit));
                        Navigator.pop(event.context);

                      },
                      child: ListTile(
                        title: Text("คลังรูปภาพ"),
                        leading: Icon(Icons.image),
                      ),
                    ),
                  ]
              ),
            ),
          );
        }
    );
  }

  @override
  Stream<ExternalState> _mapGelleryToState(
      OpenGelleryExternalEvent event) async* {
    PickedFile pickedFile = await ImagePicker()
        .getImage(source: event.camera == null ? ImageSource.gallery : ImageSource.camera, imageQuality: 60);
    File file = File(pickedFile.path);

    if (event.isEdit) {
      yield EditExternalState(null, fromImage: file);
    } else {
      yield NormalExternalState(null, fromImage: file);
    }
  }

 

  @override
  Stream<ExternalState> _mapScannerToState(
      OpenScannerExternalEvent event) async* {
    yield ScannerIsUsingExternalState();
    ScanResult result = await BarcodeScanner.scan();

    if (result.type == ResultType.Barcode) {
      if (event.isEdit) {
        yield EditExternalState(result.rawContent, fromScanner: true);
      } else {
        yield NormalExternalState(result.rawContent);
      }
    } else {
      if (event.isEdit) {
        yield EditExternalState(null);
      } else {
        yield NormalExternalState(null);
      }
    }
  }

  @override
  Stream<ExternalState> _mapScannerOnCartToState(
      OpenScannerOnCartExternalEvent event) async* {
    yield LoadingExternalState();
    ScanResult result = await BarcodeScanner.scan();

    if (result.type == ResultType.Barcode) {
      List<Product> listProduct = await FirebaseCrudBloc().readingCRUD();

      List<Product> filterList = listProduct
          .where((element) => element.serialNumber
              .toUpperCase()
              .contains(result.rawContent.toUpperCase()))
          .toList();

      if (filterList.length > 0) {
        if (int.parse(filterList[0].quantity.toString()) > 0) {
          yield NormalExternalState(null,
              isCart: true,
              notfound: false,
              productPack: ProductPack().initialProductPack(filterList[0]));
        }else {
          yield NormalExternalState(null,
              isCart: true,
              notfound: false,
              outOfStock: true,
              productPack: ProductPack().initialProductPack(filterList[0]));
          showDialogs(event.context);

        }
      } else {
        yield NormalExternalState(result.rawContent,
            isCart: true, notfound: true);
        Navigator.push(
            event.context,
            MaterialPageRoute(
              builder: (context) => new addProducts(result.rawContent),
            ));
      }
    } else {
      yield NormalExternalState(null, isCart: true);
    }
  }

  @override
  Stream<ExternalState> _increaserProductPackToState(
      IncreaseProductPackExternalEvent event) async* {

    List<Product> listProduct = await FirebaseCrudBloc().readingCRUD();

    List<Product> filterList = listProduct
        .where((element) => element.serialNumber
        .toUpperCase()
        .contains(event.productPack.product.serialNumber.toUpperCase()))
        .toList();

    if (filterList.length > 0) {

      ProductPack ppb = event.productPack;

      //ProductPack ppa = ppb.increaseCount();
      ProductPack ppa = ProductPack().initialProductPack(ppb.product);
      ppa.count = ppb.count + 1;

      if (int.parse(filterList[0].quantity.toString()) >= ppa.count) {
        yield NormalExternalState(null,
            manageProduct: true,
            isCart: true,
            productPack: ppa,
            position: event.position);
      }else {
        yield NormalExternalState(null,
            manageProduct: true,
            isCart: true,
            outOfStock: true,
            productPack: event.productPack,
            position: event.position);
        showDialogs(event.context);
      }
    }


  }

  void showDialogs(BuildContext context){
      Alert(
        context: context,
        title: "OUT OF STOCK",
//      desc: "เงินทอน 0 บาท",
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

  @override
  Stream<ExternalState> _decreaseProductPackToState(
      DecreaseProductPackExternalEvent event) async* {
    yield NormalExternalState(null,
        manageProduct: true,
        isCart: true,
        productPack: event.productPack.decreaseCount(),
        position: event.position);
  }
}
