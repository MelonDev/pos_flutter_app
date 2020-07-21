import 'package:posflutterapp/models/TransitionModel.dart';

class TransitionItem {

  final TransitionModel value;
  final String label ;
  final int count;
  final int month;
  final String price;
  final int year;
  final String createAt;

  TransitionItem(this.value, this.label,{this.count,this.month,this.year,this.price,this.createAt});



}