part of 'external_bloc.dart';

@immutable
abstract class ExternalEvent {}

class InitialExternalEvent extends ExternalEvent {
  InitialExternalEvent();
}

class OpenScannerExternalEvent extends ExternalEvent {
  final BuildContext context;
  final bool isEdit;
  OpenScannerExternalEvent(this.context,this.isEdit);
}

class OpenScannerOnCartExternalEvent extends ExternalEvent {
  final BuildContext context;
  OpenScannerOnCartExternalEvent(this.context);
}

class OpenScannerShowDetailExternalEvent extends ExternalEvent {
  final BuildContext context;
  OpenScannerShowDetailExternalEvent(this.context);
}

class OpenSearchProductExternalEvent extends ExternalEvent {
  final BuildContext context;
  OpenSearchProductExternalEvent(this.context);
}



class OpenTextSearchProductExternalEvent extends ExternalEvent {
  final BuildContext context;
  final String text;
  OpenTextSearchProductExternalEvent(this.context,this.text);
}

class OpenGelleryExternalEvent extends ExternalEvent {
  final bool isEdit;
  final bool camera;
  final BuildContext context;

  OpenGelleryExternalEvent(this.context, this.isEdit, {this.camera});
}

class OpenImageSourceExternalEvent extends ExternalEvent {
  final bool isEdit;
  final BuildContext context;

  OpenImageSourceExternalEvent(this.context, this.isEdit);
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
  IncreaseProductPackExternalEvent(
      this.productPack, this.position, this.context);
}

class DecreaseProductPackExternalEvent extends ExternalEvent {
  final ProductPack productPack;
  final int position;
  final BuildContext context;

  DecreaseProductPackExternalEvent(
      this.productPack, this.position, this.context);
}

class ReadTransitionExternalEvent extends ExternalEvent {
  ReadTransitionExternalEvent();
}

class NowadaysReadTransitionExternalEvent extends ExternalEvent {
  NowadaysReadTransitionExternalEvent();
}

class WeekReadTransitionExternalEvent extends ExternalEvent {
  WeekReadTransitionExternalEvent();
}

class MonthReadTransitionExternalEvent extends ExternalEvent {
  final int month;
  final int year;
  MonthReadTransitionExternalEvent({this.month,this.year});
}

class YearReadTransitionExternalEvent extends ExternalEvent {
  final int year;

  YearReadTransitionExternalEvent({this.year});
}

class ReportOutOfStockExternalEvent extends ExternalEvent {
  ReportOutOfStockExternalEvent();
}

class LoadTypeExternalEvent extends ExternalEvent {
  LoadTypeExternalEvent();
}

class ChooseTypeExternalEvent extends ExternalEvent {
  final bool isEdit;
  final String type;

  final BuildContext context;
  ChooseTypeExternalEvent(this.context, this.isEdit, this.type);
}

class TextInputExternalEvent extends ExternalEvent {
  final String barcode;

  final BuildContext context;

  TextInputExternalEvent(this.barcode, this.context);
}





class ShowTransitionDialogExternalEvent extends ExternalEvent {
  final BuildContext context;
  final TransitionItem item;
  final int position;
  ShowTransitionDialogExternalEvent(this.context,this.item,this.position);
}

class DeleteTransitionExternalEvent extends ExternalEvent {
  final BuildContext context;
  DeleteTransitionExternalEvent(this.context);
}

class ShowReceiptExternalEvent extends ExternalEvent {
  final BuildContext context;
  ShowReceiptExternalEvent(this.context);
}

class GeneratingReceiptExternalEvent extends ExternalEvent {
  final BuildContext context;
  GeneratingReceiptExternalEvent(this.context);
}
