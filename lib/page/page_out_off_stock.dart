import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';
import 'package:posflutterapp/components/product.dart';
import 'package:posflutterapp/page/page_add_products.dart';

class OutOffStockPage extends StatefulWidget {
  @override
  _OutOffStockPageState createState() => _OutOffStockPageState();
}

class _OutOffStockPageState extends State<OutOffStockPage> {
  ExternalBloc _externalBloc;

  @override
  Widget build(BuildContext context) {
    _externalBloc = BlocProvider.of<ExternalBloc>(context);

//    final products = Provider.of<ProductsProvider>(context);
    _externalBloc.add(ReportOutOfStockExternalEvent());

    print("building Products");
    return BlocBuilder<ExternalBloc, ExternalState>(
      builder: (BuildContext context, _state) {
        if (_state is ReportOutOfStockExternalState) {
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
                            "สินค้าหมดสต๊อก",
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
            body: _state.data.length <= 0 ? Container(child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add_box,
                    color: Colors.purple[100],
                    size: 100,
                  ), // icon
                  Text(
                    "ไม่พบข้อมูล",
                    style: TextStyle(
                        color: Colors.purple[100],
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ), // text
                ],
              ),
            ),) : GridView.builder(
                itemCount: _state.data.length ?? 0,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Single_prod(_state.data[index]),
                  );
                }),
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
