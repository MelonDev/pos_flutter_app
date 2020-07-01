import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';

import 'package:flutter_dropdown/flutter_dropdown.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
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
                      "รายงาน",
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
              DropDown<Person>(
                items: persons,
//                initialValue: selectedPerson,
                hint: Text("Select"),
                initialValue: persons.first,
                onChanged: (Person p) {
                  print(p?.gender);
                  setState(() {
                    selectedPerson = p;
                  });
                },
                isCleared: selectedPerson == null,
                customWidgets: persons.map((p) => buildDropDownRow(p)).toList(),
                isExpanded: true,

              ),

            ],
          ),
        ),
      ),
    );
  }
  Row buildDropDownRow(Person person) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(person?.gender ?? "Select",
          style: GoogleFonts.itim(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black),)
        ),
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
