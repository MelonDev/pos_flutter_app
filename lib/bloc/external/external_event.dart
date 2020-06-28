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

class OpenScannerOnCartExternalEvent extends ExternalEvent {
  final BuildContext context;
  OpenScannerOnCartExternalEvent(this.context);
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

class IncreaseProductPackExternalEvent extends ExternalEvent {
  final ProductPack productPack;
  final int position;
  final BuildContext context;
  IncreaseProductPackExternalEvent(this.productPack,this.position, this.context);
}



class DecreaseProductPackExternalEvent extends ExternalEvent {
  final ProductPack productPack;
  final int position;
  final BuildContext context;

  DecreaseProductPackExternalEvent(this.productPack,this.position, this.context);
}

