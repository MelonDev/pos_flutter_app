import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';

import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:posflutterapp/page/page_out_off_stock.dart';
import 'package:posflutterapp/page/page_sales_report.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {



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

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Material(
                        borderRadius:
                        BorderRadius.circular(10),
                        color: Colors.purple,
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () => Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (context) =>
                                  new SalesReportPage())),
                          minWidth: MediaQuery.of(context)
                              .size
                              .width,
                          child: Text(
                            "รายงานการขาย",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.itim(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Material(
                        borderRadius:
                        BorderRadius.circular(10),
                        color: Colors.purple,
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () => Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (context) =>
                                  new OutOffStockPage())),
                          minWidth: MediaQuery.of(context)
                              .size
                              .width,
                          child: Text(
                            "รายงานสินค้าหมด",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.itim(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,fontSize: 20),
                          ),
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
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    child: SpinKitSquareCircle(
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }


}
