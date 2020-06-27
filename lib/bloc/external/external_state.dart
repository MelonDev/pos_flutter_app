part of 'external_bloc.dart';

@immutable
abstract class ExternalState {}

class InitialExternalState extends ExternalState {}

class NormalExternalState extends ExternalState {
  final String barcode;
  final Product newProduct;
  final bool fromScanner;
  final File fromImage;
  final bool notfound;
  final bool isCart;
  final ProductPack productPack;

  NormalExternalState(this.barcode,{this.newProduct,this.fromScanner,this.fromImage,this.notfound,this.isCart,this.productPack});
}

class EditExternalState extends NormalExternalState {
  final bool fromScanner;
  final File fromImage;

  EditExternalState(String barcode,{this.fromScanner,this.fromImage}) : super(barcode);
}

class ScannerIsUsingExternalState extends ExternalState {}

class ScannerOnCartIsUsingExternalState extends ExternalState {}
class LoadingExternalState extends ExternalState {}



