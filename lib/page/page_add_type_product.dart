import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';
import 'package:posflutterapp/bloc/firebase_crud/firebase_crud_bloc.dart';

class PageAddTypeProduct extends StatefulWidget {

  final bool isEdit;

  PageAddTypeProduct({Key key,this.isEdit}) : super(key: key);

  @override
  _PageAddTypeProductState createState() => _PageAddTypeProductState();
}

class _PageAddTypeProductState extends State<PageAddTypeProduct> {

  ExternalBloc _externalBloc;
  FirebaseCrudBloc _firebaseCrudBloc;


  @override
  Widget build(BuildContext context) {

    _externalBloc = BlocProvider.of<ExternalBloc>(context);
    _firebaseCrudBloc = BlocProvider.of<FirebaseCrudBloc>(context);

    _externalBloc.add(LoadTypeExternalEvent());

    return BlocBuilder<ExternalBloc, ExternalState>(
      builder: (BuildContext context, _state) {

        if(_state is LoadTypeExternalState) {
          return Scaffold(
            appBar: new AppBar(
              iconTheme: new IconThemeData(color: Colors.purple),
              elevation: 0.1,
              titleSpacing: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
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
                          child: LayoutBuilder(
                            builder: (context, constraint) {
                              return FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  _externalBloc.add(InitialExternalEvent());
                                  Navigator.pop(context);
                                },
                                color: Colors.transparent,
                                child: Icon(
                                  Icons.close,
                                  size: constraint.biggest.height - 26,
                                  //color: Colors.black.withAlpha(150),
                                  color: Colors.purple,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
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
                              "เลือกประเภทสินค้า",
                              style: GoogleFonts.itim(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.purple,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                    ],
                  )
                ],
              ),
            ),
            body: ListView.builder(
              itemCount: (_state.data.length ?? 0)+1,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    if(index == 0){
                      //AD
                      // _firebaseCrudBloc.add(AddTypeFirebaseCrudEvent(this.context, {TYPE NAME},widget.isEdit));
                    }else {
                      _externalBloc.add(ChooseTypeExternalEvent(this.context,widget.isEdit,_state.data[index - 1].name));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      color: Colors.green,
                      width: MediaQuery.of(context).size.width - 8 ,
                      height: 60,
                      child: Hero(
                        tag: new Text("hero1"),
                        child: Material(
                          child: Container(
                            width: MediaQuery.of(context).size.width - 8,
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  child: Container(
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [

                                        Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width  - 8,
                                          //color: Color(0x40000000),
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Text(
                                              index == 0 ? "เพิ่มประเภทสินค้า" : _state.data[index - 1].name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                              style: GoogleFonts.itim(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: index == 0 ? Colors.orange : Colors.black87),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          );
        }else {
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