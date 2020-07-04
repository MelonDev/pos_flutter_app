import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    print("building Products");
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
                            "คลังสินค้า",
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
            body: new Column(
              children: <Widget>[
                Flexible(child: Products()),
              ],
            ),

            floatingActionButton: FloatingActionButton.extended(
              heroTag: "btn1",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return addProducts(null
//                isUpdating: false,
                        );
                  }),
                );
              },
              icon: Icon(Icons.add),
              label: Text("เพิ่มสินค้า"),
              foregroundColor: Colors.white,
              backgroundColor: Colors.orange,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );

        } else {
          return Container(
            color: Colors.purple,
          );
        }
      },
    );
  }
}
