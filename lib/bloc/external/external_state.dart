part of 'external_bloc.dart';

@immutable
abstract class ExternalState {}

class InitialExternalState extends ExternalState {}

class NormalExternalState extends ExternalState {
  final String barcode;
  final Product newProduct;

  NormalExternalState(this.barcode,{this.newProduct});
}

class EditExternalState extends NormalExternalState {
  final bool fromScanner;
  final File fromImage;

  EditExternalState(String barcode,{this.fromScanner,this.fromImage}) : super(barcode);
}

class ScannerIsUsingExternalState extends ExternalState {}
