import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/components/cart_products.dart';
import 'package:posflutterapp/page/scanner_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
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
                      child: LayoutBuilder(builder: (context, constraint) {
                        return FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.transparent,
                            child: Icon(
                              Icons.arrow_back,
                              size: constraint.biggest.height - 26,
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
                    "ตะกร้าสินค้า",
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
                Container(
                  color: Colors.transparent,
                  child: SizedBox(
                    width: 60,
                    height: 56,
                    child: LayoutBuilder(
                      builder: (lbContext, constraint) {
                        return FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            return ShowDialogPay();
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.purple,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: new Cart_Products(),
      bottomNavigationBar: Container(
        color: Colors.purple,
        height: 60,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 1.8,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "ยอดรวม : ",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.itim(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "500.00" + " ฿",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.itim(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.orange,
                      //color: Color(0x40000000),
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          "เพิ่มสินค้า",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.itim(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white),
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
    );
  }

  ShowDialogPay() {
    Alert(
      context: context,
      title: "ชำระเงิน",
      desc: "ยอดรวม 500 บาท",
      content: Form(
          child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "ระบุจำนวนเงิน"),
          ),
        ],
      ),),
      buttons: [
        DialogButton(
          child: Text("ยกเลิก"),
          color: Colors.purple,
          onPressed: () {
            Navigator.pop(context);
          },
        ),DialogButton(
          child: Text("ยืนยัน"),
          color: Colors.green,
          onPressed: () {
            Navigator.pop(context);
            return ShowDialogSuccess();
          },
        ),
      ],
    ).show();
  }

  ShowDialogSuccess() {
    Alert(
      context: context,
      title: "เสร็จสิ้น",
      desc: "เงินทอน 0 บาท",
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
