import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';

import 'package:flutter_dropdown/flutter_dropdown.dart';
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

    return BlocBuilder<ExternalBloc, ExternalState>(
      builder: (BuildContext context, _state) {
        print("HI");
        print(_state);
        if (_state is NormalExternalState) {
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
                            child:
                                LayoutBuilder(builder: (context, constraint) {
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
            body: Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      child: SfCartesianChart(
                        // Initialize category axis
                        primaryXAxis: CategoryAxis(),
                        series: <LineSeries<SalesData, String>>[
                          LineSeries<SalesData, String>(
                              // Bind data source
                              dataSource: <SalesData>[
                                SalesData('01-07', 35),
                                SalesData('02-07', 20),
                                SalesData('03-07', 40),
                                SalesData('04-07', 32),
                                SalesData('05-07', 41),
                                SalesData('06-07', 45),
                                SalesData('07-07', 50),
                                SalesData('08-07', 30),
                                SalesData('09-07', 21),
                                SalesData('10-07', 25),
                              ],
                              xValueMapper: (SalesData sales, _) => sales.year,
                              yValueMapper: (SalesData sales, _) => sales.sales)
                        ],
                      ),
                    ),
//                    Container(
//                      width: 300,
//                      child: DropDown<Person>(
//                        items: persons,
////                initialValue: selectedPerson,
//                        hint: Text("Select"),
//                        initialValue: persons.first,
//                        onChanged: (Person p) {
//                          print(p?.gender);
//                          setState(
//                            () {
//                              selectedPerson = p;
//                            },
//                          );
//                        },
//                        isCleared: selectedPerson == null,
//                        customWidgets:
//                            persons.map((p) => buildDropDownRow(p)).toList(),
//                        isExpanded: true,
//                      ),
//                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.all(20),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FlatButton(
                              onPressed: () {},
                              child: Text(
                                "รายการ",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.itim(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.deepPurpleAccent),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              onPressed: () {},
                              child: Text(
                                "ดูรายการย้อนหลัง",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.itim(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.deepPurpleAccent),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 20),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.orange[300],
                                    height: 40,
                                    alignment: Alignment.bottomLeft,
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 20),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "01-07-2563",
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
                                            "2 รายการ",
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
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 10),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "รายการที่ 1",
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
                                            "10.09 น.",
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
                                            "60 บาท",
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
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 10),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "รายการที่ 2",
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
                                            "10.09 น.",
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
                                            "100 บาท",
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
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 120,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.orange[300],
                                    height: 40,
                                    alignment: Alignment.bottomLeft,
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 20),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "30-06-2563",
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
                                            "20 รายการ",
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
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 10),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "รายการที่ 1",
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
                                            "10.09 น.",
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
                                            "60 บาท",
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
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 10),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "รายการที่ 2",
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
                                            "10.09 น.",
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
                                            "100 บาท",
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
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container(
            color: Colors.purple,
          );
        }
      },
    );
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
}

class Person {
  final String gender;
  final String name;
  final String url;

  Person({this.name, this.gender, this.url});
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
