part of 'external_bloc.dart';

@immutable
abstract class ExternalEvent {}

class InitialExternalEvent extends ExternalEvent {
  InitialExternalEvent();
}

class OpenScannerExternalEvent extends ExternalEvent {
  final bool isEdit;
  OpenScannerExternalEvent(this.isEdit);
}

class OpenGelleryExternalEvent extends ExternalEvent {
  final bool isEdit;
  OpenGelleryExternalEvent(this.isEdit);
}


class EditExternalEvent extends ExternalEvent {
  final String barcode;
  EditExternalEvent(this.barcode);
}

class BackToNormalStateExternalEvent extends ExternalEvent {
  final String barcode;
  BackToNormalStateExternalEvent(this.barcode);
}
