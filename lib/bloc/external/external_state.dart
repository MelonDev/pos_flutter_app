part of 'external_bloc.dart';

@immutable
abstract class ExternalState {}

class InitialExternalState extends ExternalState {}

class NormalExternalState extends ExternalState {
  final String barcode;

  NormalExternalState({this.barcode});
}

class ScannerIsUsingExternalState extends ExternalState {}
