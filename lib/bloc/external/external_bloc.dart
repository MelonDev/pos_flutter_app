import 'dart:async';
import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:posflutterapp/bloc/firebase_crud/firebase_crud_bloc.dart';
import 'package:posflutterapp/models/ProductPack.dart';
import 'package:posflutterapp/models/products_models.dart';

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
    }
  }

  @override
  Stream<ExternalState> _mapGelleryToState(
      OpenGelleryExternalEvent event) async* {
    PickedFile pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 60);
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

      if(filterList.length > 0){
        yield NormalExternalState(null,isCart: true,notfound: false,productPack: ProductPack().initialProductPack(filterList[0]));
      }else {
        yield NormalExternalState(result.rawContent,isCart: true,notfound: true);
      }


    } else {
      yield NormalExternalState(null,isCart: true);
    }
  }
}
