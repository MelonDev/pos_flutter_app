import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/bloc/firebase_crud/firebase_crud_bloc.dart';
import 'package:posflutterapp/widgets/register_button.dart';
import 'package:posflutterapp/widgets/save_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ChangeInfoShopPage extends StatefulWidget {
  ChangeInfoShopPage({Key key}) : super(key: key);

  @override
  _ChangeInfoShopPageState createState() => _ChangeInfoShopPageState();
}

class _ChangeInfoShopPageState extends State<ChangeInfoShopPage> {
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();
  final TextEditingController _shopTaxController = TextEditingController();
  final TextEditingController _shopNumberController = TextEditingController();

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
                      height: 60,
                      child: LayoutBuilder(builder: (context, constraint) {
                        return FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.transparent,
                            child: Icon(
                              Icons.close,
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
                      "แก้ไขข้อมูลร้าน",
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
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withAlpha(20),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _shopNameController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.shopping_cart,
                            color: Colors.purple,
                          ),
                          labelText: 'ชื่อร้าน',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _shopAddressController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.location_on,
                            color: Colors.purple,
                          ),
                          labelText: 'ที่อยู่',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _shopTaxController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.attach_file,
                            color: Colors.purple,
                          ),
                          labelText: 'เลขที่ผู้เสียภาษี',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _shopNumberController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.phone_android,
                            color: Colors.purple,
                          ),
                          labelText: 'เบอร์โทร',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SaveButton(
                        onPressed: _onFormSubmitted,
                        /*onPressed: isRegisterButtonEnabled(state)
                              ? _onFormSubmitted
                              : null,

                           */
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDialogs(BuildContext context, String title) {
    Alert(
      context: context,
      title: title ?? "",
      buttons: [
        DialogButton(
          child: Text(
            "รับทราบ",
            style: GoogleFonts.itim(color: Colors.black87),
          ),
          color: Colors.green,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    ).show();
  }

  void _onFormSubmitted() {
    FirebaseCrudBloc().editShopDetail(EditShopDetailFirebaseCrudEvent(
        this.context,
        _shopNameController.text,
        _shopAddressController.text,
        _shopTaxController.text,
        _shopNumberController.text));
    _showDialogs(context, "บันทึกเรียบร้อย");
  }
}
