import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';

import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:posflutterapp/models/SalesDataModel.dart';
import 'package:posflutterapp/models/TransitionItem.dart';
import 'package:posflutterapp/models/TransitionModel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesReportPage extends StatefulWidget {
  @override
  _SalesReportPageState createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  int _counter = 0;
  List<Person> persons = [
    Person(gender: "รายวัน"),
    Person(gender: "รายสัปดาห์"),
    Person(gender: "รายเดือน"),
  ];

  Person selectedPerson;

  @override
  void initState() {
    selectedPerson = persons.first;
    super.initState();
  }

  ExternalBloc _externalBloc;
  @override
  Widget build(BuildContext context) {
    _externalBloc = BlocProvider.of<ExternalBloc>(context);

    _externalBloc.add(WeekReadTransitionExternalEvent());

    return BlocBuilder<ExternalBloc, ExternalState>(
      builder: (BuildContext context, _state) {
        return Scaffold(
          appBar: new AppBar(
            iconTheme: new IconThemeData(color: Colors.purple),
            elevation: 0.1,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Stack(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: 60,
                          height: 56,
                          child: LayoutBuilder(builder: (context, constraint) {
                            return FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  _externalBloc.add(InitialExternalEvent());
                                  Navigator.of(context).pop();
                                },
                                color: Colors.transparent,
                                child: Icon(
                                  Icons.arrow_back,
                                  //color: Colors.black.withAlpha(150),
                                  color: Colors.purple,
                                ));
                          }),
                        )),
                  ],
                ),
                SizedBox(
                  height: 56,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "รายงานการขาย",
                          style: GoogleFonts.itim(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.purple),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: _state is ReadTransitionExternalState
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ListView.builder(
                      itemCount: _state.data.length + 3,
                      padding: EdgeInsets.only(top: 20,bottom: 40,left: 10,right: 10),
                      itemBuilder: (BuildContext listContect, int mPosition) {
                        if (mPosition == 0) {
                          return _segmentWidget(_state);
                        } else if (mPosition == 1 ) {
                          return _state.saleData.length > 0 ? _chartWidget(_state) : Container(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
//                                  Icon(
//                                    Icons.no,
//                                    color: Colors.purple[100],
//                                    size: 100,
//                                  ), // icon
                                  Text(
                                    "ไม่พบข้อมูล",
                                    style: TextStyle(
                                        color: Colors.purple[100],
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ), // text
                                ],
                              ),
                            ),
                          );
//                        } else if (mPosition == 2) {
//                          return _state.saleData.length > 0 ? _dropdownWidget(context) : SizedBox();
                        } else if (mPosition == 2) {
                          return _state.saleData.length > 0 ? _buttonWidget() : SizedBox();
                        } else {
                          int position = mPosition - 3;
                          if (_state.data[position].label != null) {
                            return _titleWidget(_state.data[position]);
                          } else {
                            return _transitionWidget(_state.data[position]);
                          }
                        }
                      },
                    ),
                  ),
                )
              : Container(
            color: Colors.white,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    child: SpinKitSquareCircle(
                      color: Colors.purple,
                      size: 50.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _segmentWidget(ReadTransitionExternalState _state) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: CupertinoSegmentedControl(
        children: _listSegment,
        borderColor: Colors.purple,
        pressedColor: Colors.purple,
        selectedColor: Colors.purple,
        groupValue: _getSegmentPosition(_state),
        onValueChanged: (int position) {
          _onTapSegment(position);
        },
      ),
    );
  }

  void _onTapSegment(int position){
    if(position == 0){
      _externalBloc.add(WeekReadTransitionExternalEvent());
    }else if(position == 1){
      _externalBloc.add(MonthReadTransitionExternalEvent());
    }else if(position == 2){
      _externalBloc.add(YearReadTransitionExternalEvent());
    }
  }

  int _getSegmentPosition(ReadTransitionExternalState _state){
    if(_state is WeekReadTransitionExternalState){
      return 0;
    }else  if(_state is MonthReadTransitionExternalState){
      return 1;
    }else  if(_state is YearReadTransitionExternalState){
      return 2;
    }else {
      return 0;
    }
  }

  final Map<int, Widget> _listSegment = <int, Widget>{
    0: Text(
      "สัปดาห์",
      style: GoogleFonts.itim(),
    ),
    1: Text(
      "เดือน",
      style: GoogleFonts.itim(),
    ),
    2: Text(
      "ปี",
      style: GoogleFonts.itim(),
    )
  };

  Widget _chartWidget(ReadTransitionExternalState _state) {
    return Container(
      height: 200,
      child: SfCartesianChart(
        // Initialize category axis
        primaryXAxis: CategoryAxis(),

        series: <LineSeries<SalesData, String>>[
          LineSeries<SalesData, String>(
              // Bind data source
              dataSource: _state.saleData,
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales,
            width: 3,
            color: Colors.purple,
            enableTooltip: false,
            markerSettings: MarkerSettings(isVisible : true,borderWidth: 3,height: 14,width: 14)
          )
        ],
      ),
    );
  }

  Widget _buttonWidget() {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.all(0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "รายการ",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.itim(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.purple),
                  )
                ],
              ),
            ),
          ),
//          Align(
//              alignment: Alignment.centerRight,
//              child: Container(
//                height: 50,
//                child: FlatButton(
//                  onPressed: () {},
//                  child: Text(
//                    "ดูรายการย้อนหลัง",
//                    overflow: TextOverflow.ellipsis,
//                    maxLines: 1,
//                    style: GoogleFonts.itim(
//                        fontWeight: FontWeight.bold,
//                        fontSize: 18,
//                        color: Colors.deepPurpleAccent),
//                  ),
//                ),
//              )),
        ],
      ),
    );
  }

  Widget _transitionWidget(TransitionItem item) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 0,color: Colors.transparent),left: BorderSide(width: 4,color: Colors.orange[300]),right: BorderSide(width: 4,color: Colors.orange[300]))
      ),
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 0),
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 14,top: 14),

      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "รายการที่ ${item.count}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.itim(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "${_loadDateForTimeLabel(item.value.createAt)} น.",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.itim(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${item.value.price} บาท",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.itim(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleWidget(TransitionItem item) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.orange[300],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 0,top: 20),
      padding: EdgeInsets.only(left: 20,right: 20),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.itim(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${item.count} รายการ",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.itim(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87),
            ),
          )
        ],
      ),
    );
  }

  String _loadDateForTimeLabel(String date) {
    var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    DateTime dateTime = formatter.parse(date);
    return "${dateTime.hour}:${dateTime.minute}";
  }

  String dropdownValue = 'January';

  Widget _dropdownWidget(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        _externalBloc.add(MonthReadTransitionExternalEvent(month: int.parse(dropdownValue)));
      },
      items: <String>[
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'Sepember',
        'October',
        'November',
        'December']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
  }

  Row buildDropDownRow(Person person) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Text(
          person?.gender ?? "Select",
          style: GoogleFonts.itim(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        )),
      ],
    );
  }


class Person {
  final String gender;
  final String name;
  final String url;

  Person({this.name, this.gender, this.url});
}
