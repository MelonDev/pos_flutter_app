import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';
import 'package:posflutterapp/bloc/firebase_crud/firebase_crud_bloc.dart';
import 'package:posflutterapp/models/ShopDetailModel.dart';
import 'package:posflutterapp/widgets/register_button.dart';
import 'package:posflutterapp/widgets/save_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ChangeInfoShopPage extends StatefulWidget {
  ChangeInfoShopPage({Key key}) : super(key: key);

  @override
  _ChangeInfoShopPageState createState() => _ChangeInfoShopPageState();
}

class _ChangeInfoShopPageState extends State<ChangeInfoShopPage> {
  TextEditingController _shopNameController = TextEditingController();
  TextEditingController _shopAddressController = TextEditingController();
  TextEditingController _shopTaxController = TextEditingController();
  TextEditingController _shopNumberController = TextEditingController();

  ShopDetailModel _shopDetailModel;

  void updateController() {
    print("B");
    if (_shopDetailModel != null) {
      print("C");
      _shopNameController.text = _shopDetailModel.shopName ?? "";
      _shopAddressController.text = _shopDetailModel.shopAddress ?? "";
      _shopTaxController.text = _shopDetailModel.shopTax ?? "";
      _shopNumberController.text = _shopDetailModel.shopNumber ?? "";
    }
  }

  ShopDetailModel ShopDetail() {
    if (_checkTextReady(_shopNameController.text) &&
        _checkTextReady(_shopAddressController.text) &&
        _checkTextReady(_shopTaxController.text) &&
        _checkTextReady(_shopNumberController.text)) {
    ShopDetailModel shopDetail = ShopDetailModel();
    shopDetail.shopName = _shopNameController.text;
    shopDetail.shopAddress = _shopAddressController.text;
    shopDetail.shopTax = _shopTaxController.text;
    shopDetail.shopNumber = _shopNumberController.text;
    return shopDetail;
    } else {
      return null;
    }
  }

  bool _checkTextReady(String text) => text.length > 0;

  ExternalBloc _externalBloc;
  FirebaseCrudBloc _firebaseCrudBloc;

  @override
  Widget build(BuildContext context) {
    updateController();
    _externalBloc = BlocProvider.of<ExternalBloc>(context);
    _firebaseCrudBloc = BlocProvider.of<FirebaseCrudBloc>(context);

    return BlocBuilder<ExternalBloc, ExternalState>(
      builder: (BuildContext context, _state) {
        print("HI");
        print(_state);
        if (_state is NormalExternalState) {
          updateController();
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
                            child:
                                LayoutBuilder(builder: (context, constraint) {
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
                              autovalidate: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'กรุณากรอกข้อมูล';
                                }
                                return null;
                              },
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
                              autovalidate: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'กรุณากรอกข้อมูล';
                                }
                                return null;
                              },
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
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.attach_file,
                                  color: Colors.purple,
                                ),
                                labelText: 'เลขที่ผู้เสียภาษี',
                                border: InputBorder.none,
                              ),
                              autovalidate: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'กรุณากรอกข้อมูล';
                                }
                                return null;
                              },
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
                              autovalidate: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'กรุณากรอกข้อมูล';
                                }
                                return null;
                              },
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
                              onPressed: () {
                                ShopDetailModel shop = ShopDetail();
                                //_validateAndUpload();

                                if (shop != null) {
                                  _onFormSubmitted();
                                  _showDialogs(context, "บันทึกเรียบร้อย");
                                } else {
                                  _showDialogIsNotEmpty(context);
                                }
                              },
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
  }

  _showDialogIsNotEmpty(BuildContext context) {
    Alert(
      context: context,

      title: "กรุณากรอกข้อมูลให้ครบ !",
      //desc: "เงินทอน ${change.toStringAsFixed(2)} บาท",
      buttons: [
        DialogButton(
          child: Text("ยืนยัน"),
          color: Colors.green,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ).show();
  }
}
