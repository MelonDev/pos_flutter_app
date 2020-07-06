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
  final bool outOfStock;

  final bool manageProduct;
  final int position;

  final String withType;

  NormalExternalState(this.barcode,{this.newProduct,this.withType,this.fromScanner,this.fromImage,this.outOfStock,this.notfound,this.isCart,this.position,this.productPack,this.manageProduct});
}

class EditExternalState extends NormalExternalState {
  final bool fromScanner;
  final File fromImage;
  final String withType;

  EditExternalState(String barcode,{this.fromScanner,this.fromImage,this.withType}) : super(barcode);
}

class ScannerIsUsingExternalState extends ExternalState {}

class ScannerOnCartIsUsingExternalState extends ExternalState {


}
class LoadingExternalState extends ExternalState {}

class ReadTransitionExternalState extends ExternalState {
  final List<TransitionItem> data;

  final List<SalesData> saleData;

  ReadTransitionExternalState(this.data,this.saleData);
}

class WeekReadTransitionExternalState extends ReadTransitionExternalState {
  WeekReadTransitionExternalState(List<TransitionItem> data, List<SalesData> saleData) : super(data, saleData);
}

class MonthReadTransitionExternalState extends ReadTransitionExternalState {
  MonthReadTransitionExternalState(List<TransitionItem> data, List<SalesData> saleData) : super(data, saleData);
}

class YearReadTransitionExternalState extends ReadTransitionExternalState {
  YearReadTransitionExternalState(List<TransitionItem> data, List<SalesData> saleData) : super(data, saleData);
}

class ReportOutOfStockExternalState extends ExternalState {
  final List<Product> data;

  ReportOutOfStockExternalState(this.data);
}

class ChooseTypeExternalState extends ExternalState {

  ChooseTypeExternalState();
}

class LoadTypeExternalState extends ExternalState {
  final List<TypeModel> data;

  LoadTypeExternalState(this.data);
}
