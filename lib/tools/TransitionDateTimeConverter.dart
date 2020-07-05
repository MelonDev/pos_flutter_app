import 'package:intl/intl.dart';
import 'package:posflutterapp/models/TransitionItem.dart';
import 'package:posflutterapp/models/TransitionModel.dart';

class TransitionDateTimeConverter {

  List<TransitionItem> compareTransitionItemList(
      List<TransitionModel> originalList) {
    List<TransitionItem> newList = [];
    DateTime _datetime;
    int counter = 0;
    int mCount = 0;
    double mPrice = 0;
    int month = 0;
    for (var data in originalList) {
      var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      DateTime dateTime = formatter.parse(data.createAt);
      DateTime _date = DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0, 0, 0);
      if (_datetime == null) {
        _datetime = _date;
      }
      if (_date.isAfter(_datetime)) {

        newList.add(TransitionItem(null, _loadDateForLabel(formatter.format(_datetime)),count: mCount,month: month,price: mPrice.toStringAsFixed(2)));
        mCount = 0;
        mPrice = 0;
        month = 0;

        mCount+=1;
        mPrice += double.parse(data.price);
        month = dateTime.month;

        newList.add(TransitionItem(data, null,count: mCount));
        _datetime = _date;
      } else {
        mCount += 1;
        mPrice += double.parse(data.price);
        month = dateTime.month;
        newList.add(TransitionItem(data, null,count: mCount));
      }
      counter++;
      if(counter == originalList.length){
        newList.add(TransitionItem(null, _loadDateForLabel(formatter.format(_datetime)),count: mCount,month: month,price: mPrice.toStringAsFixed(2)));
        mCount = 0;
        mPrice = 0;
        month = 0;
      }

    }
    return newList;
  }

  String _loadDateForLabel(String date) {
    var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    DateTime dateTime = formatter.parse(date);
    return "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year + 543}";
  }

  String _getMonthName(int monthInt) {
    String month = "";
    switch (monthInt) {
      case 1:
        month = "มกราคม";
        break;
      case 2:
        month = "กุมภาพันธ์";
        break;
      case 3:
        month = "มีนาคม";
        break;
      case 4:
        month = "เมษายน";
        break;
      case 5:
        month = "พฤษภาคม";
        break;
      case 6:
        month = "มิถุนายน";
        break;
      case 7:
        month = "กรกฎาคม";
        break;
      case 8:
        month = "สิงหาคม";
        break;
      case 9:
        month = "กันยายน";
        break;
      case 10:
        month = "ตุลาคม";
        break;
      case 11:
        month = "พฤษจิกายน";
        break;
      case 12:
        month = "ธันวาคม";
        break;
    }
    return month;
  }


}