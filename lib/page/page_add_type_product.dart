import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';
import 'package:posflutterapp/bloc/firebase_crud/firebase_crud_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PageAddTypeProduct extends StatefulWidget {
  final bool isEdit;
  final bool isPage;

  PageAddTypeProduct({Key key, this.isPage, this.isEdit}) : super(key: key);

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
        if (_state is LoadTypeExternalState) {
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
                          widget.isPage ? "ประเภทสินค้า" : "เลือกประเภทสินค้า",
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
                    children: <Widget>[],
                  )
                ],
              ),
            ),
            body: ListView.builder(
              itemCount: (_state.data.length ?? 0) + 1,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      //AD
                      // _firebaseCrudBloc.add(AddTypeFirebaseCrudEvent(this.context, {TYPE NAME},widget.isEdit));
                      _showDialogTextTypeInput(context,widget.isPage);
                    } else {
                      if (!widget.isPage) {
                        _externalBloc.add(ChooseTypeExternalEvent(this.context,
                            widget.isEdit, _state.data[index - 1].name));
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      color: Colors.green,
                      width: MediaQuery.of(context).size.width - 8,
                      height: 60,
                      child: Hero(
                        tag: new Text("hero1"),
                        child: Material(
                          child: Container(
                            width: MediaQuery.of(context).size.width - 8,
                            child: Stack(
                              children: <Widget>[

                                widget.isPage ? (index != 0 ? (_state.data[index-1].id != null ?Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    height: 60,
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {_showDialogTextTypeInput(context,widget.isPage,text:_state.data[index - 1].name,id: _state.data[index - 1].id);}),
                                        IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              _firebaseCrudBloc.add(AddTypeFirebaseCrudEvent(
                                                  this.context,false, null, widget.isEdit,id:_state.data[index - 1].id,delete: true));
                                            })
                                      ],
                                    ),
                                  ),
                                ):Container()):Container()):Container(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              8,
                                          //color: Color(0x40000000),
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Text(
                                              index == 0
                                                  ? "เพิ่มประเภทสินค้า"
                                                  : _state.data[index - 1].name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                              style: GoogleFonts.itim(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: index == 0
                                                      ? Colors.orange
                                                      : Colors.black87),
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

  _showDialogTextTypeInput(BuildContext context,bool isPage,{String text,String id}) {
    TextEditingController _textInputController = TextEditingController();
    if(text != null){
      _textInputController.text = text;
    }
    Alert(
      context: context,
      title: "${text != null ?"แก้ไข":"เพิ่ม"}ประเภทสินค้า",
      content: Form(
        child: Column(
          children: [
            TextFormField(
              controller: _textInputController,
              decoration: InputDecoration(labelText: "ระบุประเภทสินค้า"),
            ),
          ],
        ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "ยกเลิก",
            style: GoogleFonts.itim(color: Colors.black87),
          ),
          color: Colors.black12,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text(
            "ยืนยัน",
            style: GoogleFonts.itim(color: Colors.black87),
          ),
          color: Colors.lightGreenAccent,
          onPressed: () {
            BlocProvider.of<ExternalBloc>(context).add(InitialExternalEvent());
            if (_textInputController.text.length > 0) {
              if(text == null && !isPage) {
                _firebaseCrudBloc.add(AddTypeFirebaseCrudEvent(
                    this.context,true, _textInputController.text, widget.isEdit));
//              _externalBloc.add(
//                  TextInputExternalEvent(_TextInputController.text, context));
              }else {

                _firebaseCrudBloc.add(AddTypeFirebaseCrudEvent(
                    this.context,false, _textInputController.text, widget.isEdit,id:id));
              }
              Navigator.pop(context);
            }
          },
        ),
      ],
    ).show();
  }
}
