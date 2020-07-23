import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/bloc/authentication/authentication_bloc.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';
import 'package:posflutterapp/page/change_info_shop_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
                      "ตั้งค่า",
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new ChangeInfoShopPage()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        Icon(
                          Icons.mode_edit,
                          color: Colors.purple,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "แก้ไขข้อมูลร้าน",
                          style: GoogleFonts.itim(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              color: Colors.purple),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                GestureDetector(
                  onTap: () {
                    _showDialogTextInput(this.context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        Icon(
                          Icons.vpn_key,
                          color: Colors.purple,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "เปลี่ยนรหัสผ่าน",
                          style: GoogleFonts.itim(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              color: Colors.purple),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      AuthenticationLoggedOut(),
                    );
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.purple,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "ออกจากระบบ",
                          style: GoogleFonts.itim(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              color: Colors.purple),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDialogTextInput(BuildContext context) {
    TextEditingController textInputController = TextEditingController();
    Alert(
      context: context,
      title: "กรอกรหัสใหม่",
      content: Form(
        child: Column(
          children: [
            TextFormField(
              controller: textInputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "ระบุรหัส"),
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
          color: Colors.green,
          onPressed: () {
            if (textInputController.text.length > 0) {
              _changePassword(textInputController.text);
              Navigator.pop(context);
            }
          },
        ),
      ],
    ).show();
  }

  void _changePassword(String password) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    user.updatePassword(password).then((_) {
      _showDialogs(this.context, "เปลี่ยนรหัสเรียบร้อย");
    }).catchError((error) {
      _showDialogs(this.context, "ผิดพลาด");
    });
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
          },
        ),
      ],
    ).show();
  }
}
