import 'package:posflutterapp/models/TransitionModel.dart';

class TransitionItem {

  final TransitionModel value;
  final String label ;
  final int count;
  final int month;
  final String price;

  TransitionItem(this.value, this.label,{this.count,this.month,this.price});



}