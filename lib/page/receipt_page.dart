import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';
import 'package:posflutterapp/models/ShopDetailModel.dart';
import 'package:posflutterapp/models/TransitionItem.dart';
import 'package:posflutterapp/tools/my_separator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:ui' as ui;

import 'package:save_in_gallery/save_in_gallery.dart';

class ReceiptPage extends StatefulWidget {
  final TransitionItem item;
  final ShopDetailModel detail;

  ReceiptPage(this.item, this.detail, {Key key}) : super(key: key);

  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  ExternalBloc _externalBloc;

  //GlobalKey _globalKey = new GlobalKey();
  GlobalKey<OverRepaintBoundaryState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _externalBloc = BlocProvider.of<ExternalBloc>(context);

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
                      "ใบเสร็จ",
                      style: GoogleFonts.itim(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.purple),
                    ),
                  )
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
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
                              _saveImage();
                            },
                            color: Colors.transparent,
                            child: Icon(
                              Icons.save_alt,
                              //color: Colors.black.withAlpha(150),
                              color: Colors.purple,
                            ));
                      }),
                    )),
              ],
            )
          ],
        ),
      ),
      body: Container(
        color: Colors.black12,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          //key: _globalKey,

          child: Container(
            child: RepaintBoundary(
              key: _globalKey,
              child: Container(
                padding: EdgeInsets.only(top: 40, bottom: 40),
                width: MediaQuery.of(context).size.width - 20,
                color: Colors.white,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        widget.detail.shopName ?? "ชื่อร้าน",
                        style: GoogleFonts.itim(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black54),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15, left: 0),
                      child: Text(
                        "ที่อยู่ : ${widget.detail.shopAddress}",
                        style: GoogleFonts.itim(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black54),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15, left: 30),
                      child: Text(
                        "เลขที่ผู้เสียภาษี : ${widget.detail.shopTax}",
                        style: GoogleFonts.itim(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black54),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15, left: 30),
                      child: Text(
                        "เบอร์โทร : ${widget.detail.shopNumber}",
                        style: GoogleFonts.itim(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black54),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Container(
                        color: Colors.black54,
                        height: 3,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              "เลขรายการ :",
                              style: GoogleFonts.itim(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: Colors.black54),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 160,
                            child: Text(
                              "${widget.item.value.id.toUpperCase()}",
                              style: GoogleFonts.itim(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              "วันที่เวลา :",
                              style: GoogleFonts.itim(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: Colors.black54),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 160,
                            child: Text(
                              "${_loadDateForLabel(widget.item.value.createAt)}",
                              style: GoogleFonts.itim(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: MySeparator(
                        height: 3,
                        color: Colors.black54,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: ((MediaQuery.of(context).size.width - 60) /
                                    20) *
                                8,
                            child: Text(
                              "ชื่อสินค้า",
                              style: GoogleFonts.itim(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.black54),
                            ),
                          ),
                          Container(
                            width: ((MediaQuery.of(context).size.width - 60) /
                                    20) *
                                3,
                            child: Text(
                              "จำนวน",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.itim(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.black54),
                            ),
                          ),
                          Container(
                            width: ((MediaQuery.of(context).size.width - 60) /
                                    20) *
                                4,
                            child: Text(
                              "ราคา/ชิ้น",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.itim(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.black54),
                            ),
                          ),
                          Container(
                            width: ((MediaQuery.of(context).size.width - 60) /
                                    20) *
                                5,
                            child: Text(
                              "ราคารวม",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.itim(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: List.generate(widget.item.value.cart.length,
                          (position) {
                        return Container(
                          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width:
                                    ((MediaQuery.of(context).size.width - 60) /
                                            20) *
                                        8,
                                child: Text(
                                  "${widget.item.value.cart[position].product.name}",
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),
                              ),
                              Container(
                                width:
                                    ((MediaQuery.of(context).size.width - 60) /
                                            20) *
                                        3,
                                child: Text(
                                  "${widget.item.value.cart[position].amount}",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),
                              ),
                              Container(
                                width:
                                    ((MediaQuery.of(context).size.width - 60) /
                                            20) *
                                        4,
                                child: Text(
                                  "${widget.item.value.cart[position].product.salePrice}",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),
                              ),
                              Container(
                                width:
                                    ((MediaQuery.of(context).size.width - 60) /
                                            20) *
                                        5,
                                child: Text(
                                  "${(widget.item.value.cart[position].amount * double.parse(widget.item.value.cart[position].product.salePrice)).toStringAsFixed(2)}",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                      child: MySeparator(
                        height: 3,
                        color: Colors.black54,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: ((MediaQuery.of(context).size.width - 60) /
                                      4) *
                                  3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "รวมทั้งสิ้น",
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.itim(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color: Colors.black54),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    color: Colors.black54,
                                    height: 3,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${widget.item.value.price} บาท",
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.itim(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: Colors.black54),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 140,
                                        child: Text(
                                          "จำนวนเงินที่รับ :",
                                          style: GoogleFonts.itim(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 20,
                                              color: Colors.black54),
                                        ),
                                      ),
                                      Container(
                                        width: ((MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        60) /
                                                    4) *
                                                3 -
                                            140,
                                        child: Text(
                                          "${widget.item.value.receiveMoney}",
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.itim(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 20,
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 140,
                                        child: Text(
                                          "เงินทอน :",
                                          style: GoogleFonts.itim(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 20,
                                              color: Colors.black54),
                                        ),
                                      ),
                                      Container(
                                        width: ((MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        60) /
                                                    4) *
                                                3 -
                                            140,
                                        child: Text(
                                          "${(double.parse(widget.item.value.receiveMoney) - double.parse(widget.item.value.price)).toStringAsFixed(2)}",
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.itim(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 20,
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                /*child: ListView.builder(
                    itemCount: 100,
                    padding: EdgeInsets.only(top: 40),
                    itemBuilder: (context, position) {
                      if (position == 0) {
                        return Center(
                          child: Text(
                            widget.detail.shopName ?? "ชื่อร้าน",
                            style: GoogleFonts.itim(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black54),
                          ),
                        );
                      } else if (position == 1) {
                        return Container(
                          margin: EdgeInsets.only(top: 15, left: 30),
                          child: Text(
                            "ที่อยู่ : ${widget.detail.shopAddress}",
                            style: GoogleFonts.itim(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black54),
                          ),
                        );
                      } else if (position == 2) {
                        return Container(
                          margin: EdgeInsets.only(top: 15, left: 30),
                          child: Text(
                            "เลขที่ผู้เสียภาษี : ${widget.detail.shopTax}",
                            style: GoogleFonts.itim(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black54),
                          ),
                        );
                      } else if (position == 3) {
                        return Container(
                          margin: EdgeInsets.only(top: 15, left: 30),
                          child: Text(
                            "เบอร์โทร : ${widget.detail.shopNumber}",
                            style: GoogleFonts.itim(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black54),
                          ),
                        );
                      } else if (position == 4) {
                        return Container(
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Container(
                            color: Colors.black54,
                            height: 3,
                          ),
                        );
                      } else if (position == 5) {
                        return Container(
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                child: Text(
                                  "เลขรายการ :",
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 160,
                                child: Text(
                                  "${widget.item.value.id.toUpperCase()}",
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (position == 6) {
                        return Container(
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                child: Text(
                                  "วันที่เวลา :",
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 160,
                                child: Text(
                                  "${_loadDateForLabel(widget.item.value.createAt)}",
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (position == 7) {
                        return Container(
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: MySeparator(
                            height: 3,
                            color: Colors.black54,
                          ),
                        );
                      } else if (position == 8) {
                        return Container(
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width:
                                    ((MediaQuery.of(context).size.width - 60) /
                                            20) *
                                        8,
                                child: Text(
                                  "ชื่อสินค้า",
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Colors.black54),
                                ),
                              ),
                              Container(
                                width:
                                    ((MediaQuery.of(context).size.width - 60) /
                                            20) *
                                        3,
                                child: Text(
                                  "จำนวน",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Colors.black54),
                                ),
                              ),
                              Container(
                                width:
                                    ((MediaQuery.of(context).size.width - 60) /
                                            20) *
                                        4,
                                child: Text(
                                  "ราคา/ชิ้น",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Colors.black54),
                                ),
                              ),
                              Container(
                                width:
                                    ((MediaQuery.of(context).size.width - 60) /
                                            20) *
                                        5,
                                child: Text(
                                  "ราคารวม",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (position >= 9 &&
                          position < 9 + widget.item.value.cart.length) {
                        return Container(
                          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width:
                                    ((MediaQuery.of(context).size.width - 60) /
                                            20) *
                                        8,
                                child: Text(
                                  "${widget.item.value.cart[position - 9].product.name}",
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),
                              ),
                              Container(
                                width:
                                    ((MediaQuery.of(context).size.width - 60) /
                                            20) *
                                        3,
                                child: Text(
                                  "${widget.item.value.cart[position - 9].amount}",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),
                              ),
                              Container(
                                width:
                                    ((MediaQuery.of(context).size.width - 60) /
                                            20) *
                                        4,
                                child: Text(
                                  "${widget.item.value.cart[position - 9].product.salePrice}",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),
                              ),
                              Container(
                                width:
                                    ((MediaQuery.of(context).size.width - 60) /
                                            20) *
                                        5,
                                child: Text(
                                  "${(widget.item.value.cart[position - 9].amount * double.parse(widget.item.value.cart[position - 9].product.salePrice)).toStringAsFixed(2)}",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (position ==
                          10 + widget.item.value.cart.length) {
                        return Container(
                          margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                          child: MySeparator(
                            height: 3,
                            color: Colors.black54,
                          ),
                        );
                      } else if (position ==
                          11 + widget.item.value.cart.length) {
                        return Container(
                          margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: ((MediaQuery.of(context).size.width -
                                              60) /
                                          4) *
                                      3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "รวมทั้งสิ้น",
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.itim(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                            color: Colors.black54),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        color: Colors.black54,
                                        height: 3,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${widget.item.value.price} บาท",
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.itim(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 40,
                                            color: Colors.black54),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 140,
                                            child: Text(
                                              "จำนวนเงินที่รับ :",
                                              style: GoogleFonts.itim(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 20,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                          Container(
                                            width: ((MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            60) /
                                                        4) *
                                                    3 -
                                                140,
                                            child: Text(
                                              "${widget.item.value.receiveMoney}",
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.itim(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 20,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 140,
                                            child: Text(
                                              "เงินทอน :",
                                              style: GoogleFonts.itim(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 20,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                          Container(
                                            width: ((MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            60) /
                                                        4) *
                                                    3 -
                                                140,
                                            child: Text(
                                              "${(double.parse(widget.item.value.receiveMoney) - double.parse(widget.item.value.price)).toStringAsFixed(2)}",
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.itim(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 20,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),

                 */
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveImage() async {
    Uint8List image = await _capturePng();
    List<Uint8List> list = [];
    list.add(image);
    //final res = await ImageSaver().saveImages(imageBytes: list);
    final res = await ImageGallerySaver.saveImage(image,
        quality: 100, name: DateTime.now().toString());
    showDialogsSuccess();
    print(res);
  }

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();

      ui.Image image = await boundary.toImage();

      //ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  void showDialogsSuccess() {
    Alert(
      context: this.context,
      title: "บันทึกเรียบร้อย",
//      desc: "เงินทอน 0 บาท",
      buttons: [
        DialogButton(
          child: Text(
            "ปิด",
            style: GoogleFonts.itim(color: Colors.black87),
          ),
          color: Colors.black12,
          onPressed: () {
            Navigator.pop(this.context);
          },
        ),
      ],
    ).show();
  }

  String _loadDateForLabel(String date) {
    var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    DateTime dateTime = formatter.parse(date);
    return "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year + 543} (${dateTime.hour}:${dateTime.minute})";
  }

  String _getMonthName(int monthInt) {
    String month = "";
    switch (monthInt) {
      case 1:
        month = "มกราคม";
        break;
      case 2:
        month = "กุมภาพันธ์";
        break;
      case 3:
        month = "มีนาคม";
        break;
      case 4:
        month = "เมษายน";
        break;
      case 5:
        month = "พฤษภาคม";
        break;
      case 6:
        month = "มิถุนายน";
        break;
      case 7:
        month = "กรกฎาคม";
        break;
      case 8:
        month = "สิงหาคม";
        break;
      case 9:
        month = "กันยายน";
        break;
      case 10:
        month = "ตุลาคม";
        break;
      case 11:
        month = "พฤษจิกายน";
        break;
      case 12:
        month = "ธันวาคม";
        break;
    }
    return month;
  }
}

class UiImagePainter extends CustomPainter {
  final ui.Image image;

  UiImagePainter(this.image);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    // simple aspect fit for the image
    var hr = size.height / image.height;
    var wr = size.width / image.width;

    double ratio;
    double translateX;
    double translateY;
    if (hr < wr) {
      ratio = hr;
      translateX = (size.width - (ratio * image.width)) / 2;
      translateY = 0.0;
    } else {
      ratio = wr;
      translateX = 0.0;
      translateY = (size.height - (ratio * image.height)) / 2;
    }

    canvas.translate(translateX, translateY);
    canvas.scale(ratio, ratio);
    canvas.drawImage(image, new Offset(0.0, 0.0), new Paint());
  }

  @override
  bool shouldRepaint(UiImagePainter other) {
    return other.image != image;
  }
}

class UiImageDrawer extends StatelessWidget {
  final ui.Image image;

  const UiImageDrawer({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: UiImagePainter(image),
    );
  }
}

class OverRepaintBoundary extends StatefulWidget {
  final Widget child;

  const OverRepaintBoundary({Key key, this.child}) : super(key: key);

  @override
  OverRepaintBoundaryState createState() => OverRepaintBoundaryState();
}

class OverRepaintBoundaryState extends State<OverRepaintBoundary> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
