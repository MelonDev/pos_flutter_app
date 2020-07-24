import 'dart:async';
import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:posflutterapp/bloc/firebase_crud/firebase_crud_bloc.dart';
import 'package:posflutterapp/models/CartModel.dart';
import 'package:posflutterapp/models/ProductPack.dart';
import 'package:posflutterapp/models/SalesDataModel.dart';
import 'package:posflutterapp/models/ShopDetailModel.dart';
import 'package:posflutterapp/models/TransitionItem.dart';
import 'package:posflutterapp/models/TransitionModel.dart';
import 'package:posflutterapp/models/TypeModel.dart';
import 'package:posflutterapp/models/products_models.dart';
import 'package:posflutterapp/page/page_add_products.dart';
import 'package:posflutterapp/page/page_products_details.dart';
import 'package:posflutterapp/page/receipt_page.dart';
import 'package:posflutterapp/tools/TypeTool.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

part 'external_event.dart';

part 'external_state.dart';

class ExternalBloc extends Bloc<ExternalEvent, ExternalState> {
  @override
  ExternalState get initialState => InitialExternalState();

  @override
  Stream<ExternalState> mapEventToState(ExternalEvent event) async* {
    print(event);
    if (event is InitialExternalEvent) {
      yield NormalExternalState(null);
    } else if (event is OpenScannerExternalEvent) {
      yield* _mapScannerToState(event);
    } else if (event is EditExternalEvent) {
      yield EditExternalState(event.barcode);
    } else if (event is BackToNormalStateExternalEvent) {
      yield NormalExternalState(event.barcode);
    } else if (event is OpenGelleryExternalEvent) {
      yield* _mapGelleryToState(event);
    } else if (event is OpenScannerOnCartExternalEvent) {
      yield* _mapScannerOnCartToState(event);
    } else if (event is OpenScannerShowDetailExternalEvent) {
      yield* _mapScannerShowDetailToState(event);
    } else if (event is OpenSearchProductExternalEvent) {
      yield* _mapSearchProductToState(event);
    } else if (event is OpenTextSearchProductExternalEvent) {
      yield* _mapTextShowDetailToState(event);
    } else if (event is IncreaseProductPackExternalEvent) {
      yield* _increaserProductPackToState(event);
    } else if (event is DecreaseProductPackExternalEvent) {
      yield* _decreaseProductPackToState(event);
    } else if (event is OpenImageSourceExternalEvent) {
      yield* _mapImageSourceToState(event);
    } else if (event is NowadaysReadTransitionExternalEvent) {
      yield* _nowadaysReadTransitionToState(event);
    } else if (event is WeekReadTransitionExternalEvent) {
      yield* _weekReadTransitionToState(event);
    } else if (event is MonthReadTransitionExternalEvent) {
      yield* _monthReadTransitionToState(event);
    } else if (event is YearReadTransitionExternalEvent) {
      yield* _yearReadTransitionToState(event);
    } else if (event is ReportOutOfStockExternalEvent) {
      yield* _reportOutOfStockToState(event);
    } else if (event is ChooseTypeExternalEvent) {
      yield* _chooseTypeToState(event);
    } else if (event is LoadTypeExternalEvent) {
      yield* _loadTypeToState(event);
    } else if (event is TextInputExternalEvent) {
      yield* _mapTextInputOnCartToState(event);
    } else if (event is ShowTransitionDialogExternalEvent) {
      yield* _mapTransitionDialogToState(event);
    }
  }

  @override
  Stream<ExternalState> _mapImageSourceToState(
      OpenImageSourceExternalEvent event) async* {
    showDialog(
        context: event.context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: double.maxFinite,
              height: 100,
              child: ListView(children: <Widget>[
                InkWell(
                  onTap: () {
                    this.add(OpenGelleryExternalEvent(
                        event.context, event.isEdit,
                        camera: true));
                    Navigator.pop(event.context);
                  },
                  child: ListTile(
                    title: Text("กล้อง"),
                    leading: Icon(Icons.camera),
                  ),
                ),
                InkWell(
                  onTap: () {
                    this.add(
                        OpenGelleryExternalEvent(event.context, event.isEdit));
                    Navigator.pop(event.context);
                  },
                  child: ListTile(
                    title: Text("คลังรูปภาพ"),
                    leading: Icon(Icons.image),
                  ),
                ),
              ]),
            ),
          );
        });
  }

  @override
  Stream<ExternalState> _mapSearchProductToState(
      OpenSearchProductExternalEvent event) async* {
    _showDialogSelect(event.context);
  }

  @override
  Stream<ExternalState> _mapGelleryToState(
      OpenGelleryExternalEvent event) async* {
    PickedFile pickedFile = await ImagePicker().getImage(
        source: event.camera == null ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 60);
    File file = File(pickedFile.path);

    if (event.isEdit) {
      yield EditExternalState(null, fromImage: file);
    } else {
      yield NormalExternalState(null, fromImage: file);
    }
  }

  @override
  Stream<ExternalState> _mapScannerToState(
      OpenScannerExternalEvent event) async* {
    yield ScannerIsUsingExternalState();
    ScanResult result = await BarcodeScanner.scan();

    if (result.type == ResultType.Barcode) {
      List<Product> listProduct = await FirebaseCrudBloc().readingCRUD();

      List<Product> filterList = listProduct
          .where((element) => element.serialNumber
              .toUpperCase()
              .contains(result.rawContent.toUpperCase()))
          .toList();

      if (filterList.length > 0) {
        showDialogsHaveProduct(event.context, result.rawContent);
        if (event.isEdit) {
          yield EditExternalState(result.rawContent);
        } else {
          yield NormalExternalState(result.rawContent);
        }
      } else {
        if (event.isEdit) {
          yield EditExternalState(result.rawContent, fromScanner: true);
        } else {
          yield NormalExternalState(result.rawContent, fromScanner: true);
        }
      }
    } else {
      if (event.isEdit) {
        yield EditExternalState(null);
      } else {
        yield NormalExternalState(null);
      }
    }
  }

  @override
  Stream<ExternalState> _mapScannerOnCartToState(
      OpenScannerOnCartExternalEvent event) async* {
    yield LoadingExternalState();
    ScanResult result = await BarcodeScanner.scan();

    if (result.type == ResultType.Barcode) {
      List<Product> listProduct = await FirebaseCrudBloc().readingCRUD();

      List<Product> filterList = listProduct
          .where((element) => element.serialNumber
              .toUpperCase()
              .contains(result.rawContent.toUpperCase()))
          .toList();

      if (filterList.length > 0) {
        if (filterList[0].serialNumber.length == result.rawContent.length) {
          if (int.parse(filterList[0].quantity.toString()) > 0) {
            yield NormalExternalState(null,
                isCart: true,
                notfound: false,
                productPack: ProductPack().initialProductPack(filterList[0]));
          } else {
            yield NormalExternalState(null,
                isCart: true,
                notfound: false,
                //outOfStock: true,
                productPack: ProductPack().initialProductPack(filterList[0]));
            showDialogsOut(event.context);
          }
        } else {
          yield NormalExternalState(result.rawContent,
              isCart: true, notfound: true);
          showDialogsNoProduct(event.context, result.rawContent);
        }
      } else {
        yield NormalExternalState(result.rawContent,
            isCart: true, notfound: true);
        showDialogsNoProduct(event.context, result.rawContent);
//        Navigator.push(
//            event.context,
//            MaterialPageRoute(
//              builder: (context) => new addProducts(result.rawContent),
//            ));
      }
    } else {
      yield NormalExternalState(null, isCart: true);
    }
  }

  @override
  Stream<ExternalState> _mapScannerShowDetailToState(
      OpenScannerShowDetailExternalEvent event) async* {
    yield LoadingExternalState();
    ScanResult result = await BarcodeScanner.scan();

    if (result.type == ResultType.Barcode) {
      List<Product> listProduct = await FirebaseCrudBloc().readingCRUD();

      List<Product> filterList = listProduct
          .where((element) => element.serialNumber
              .toUpperCase()
              .contains(result.rawContent.toUpperCase()))
          .toList();

      if (filterList.length > 0) {
        if (filterList[0].serialNumber.length == result.rawContent.length) {
          yield NormalExternalState(result.rawContent);

          Navigator.push(
            event.context,
            MaterialPageRoute(
              builder: (context) => ProductDetail(filterList[0], event.context),
            ),
          );
        } else {
          yield NormalExternalState(result.rawContent,
              isCart: true, notfound: true);
          showDialogsNoProduct(event.context, result.rawContent);
        }
      } else {
        yield NormalExternalState(result.rawContent,
            isCart: true, notfound: true);
        showDialogsNoProduct(event.context, result.rawContent);
      }
    } else {
      yield NormalExternalState(null, isCart: true);
    }
  }

  @override
  Stream<ExternalState> _mapTextShowDetailToState(
      OpenTextSearchProductExternalEvent event) async* {
    yield LoadingExternalState();
    List<Product> listProduct = await FirebaseCrudBloc().readingCRUD();

    List<Product> filterList = listProduct
        .where((element) => element.serialNumber
            .toUpperCase()
            .contains(event.text.toUpperCase()))
        .toList();

    if (filterList.length > 0) {
      if (filterList[0].serialNumber.length == event.text.length) {
        yield NormalExternalState(event.text);

        Navigator.push(
          event.context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(filterList[0], event.context),
          ),
        );
      } else {
        yield NormalExternalState(event.text, isCart: true, notfound: true);
        showDialogsNoProduct(event.context, event.text);
      }
    } else {
      yield NormalExternalState(event.text, isCart: true, notfound: true);
      showDialogsNoProduct(event.context, event.text);
    }
  }

  @override
  Stream<ExternalState> _mapTextInputOnCartToState(
      TextInputExternalEvent event) async* {
    yield LoadingExternalState();

    List<Product> listProduct = await FirebaseCrudBloc().readingCRUD();

    List<Product> filterList = listProduct
        .where((element) => element.serialNumber
            .toUpperCase()
            .contains(event.barcode.toUpperCase()))
        .toList();

    if (filterList.length > 0) {
      if (filterList[0].serialNumber.length == event.barcode.length) {
        if (int.parse(filterList[0].quantity.toString()) > 0) {
          yield NormalExternalState(null,
              isCart: true,
              notfound: false,
              productPack: ProductPack().initialProductPack(filterList[0]));
        } else {
          yield NormalExternalState(null,
              isCart: true,
              notfound: false,
              //outOfStock: true,
              productPack: ProductPack().initialProductPack(filterList[0]));
          showDialogsOut(event.context);
        }
      } else {
        yield NormalExternalState(event.barcode, isCart: true, notfound: true);
        showDialogsNoProduct(event.context, event.barcode);
      }
    } else {
      yield NormalExternalState(event.barcode, isCart: true, notfound: true);
      showDialogsNoProduct(event.context, event.barcode);
//        Navigator.push(
//            event.context,
//            MaterialPageRoute(
//              builder: (context) => new addProducts(result.rawContent),
//            ));
    }
  }

  @override
  Stream<ExternalState> _increaserProductPackToState(
      IncreaseProductPackExternalEvent event) async* {
    List<Product> listProduct = await FirebaseCrudBloc().readingCRUD();

    List<Product> filterList = listProduct
        .where((element) => element.serialNumber
            .toUpperCase()
            .contains(event.productPack.product.serialNumber.toUpperCase()))
        .toList();

    if (filterList.length > 0) {
      ProductPack ppb = event.productPack;

      //ProductPack ppa = ppb.increaseCount();
      ProductPack ppa = ProductPack().initialProductPack(ppb.product);
      ppa.count = ppb.count + 1;

      if (int.parse(filterList[0].quantity.toString()) >= ppa.count) {
        yield NormalExternalState(null,
            manageProduct: true,
            isCart: true,
            productPack: ppa,
            position: event.position);
      } else {
        yield NormalExternalState(null,
            manageProduct: true,
            isCart: true,
            //outOfStock: true,
            //productPack: event.productPack,
            productPack: ppa,
            position: event.position);
        showDialogsOut(event.context);
      }
    }
  }

  void showDialogsOut(BuildContext context) {
    Alert(
      context: context,
      title: "สินค้าหมด",
      desc: "กรุณาเพิ่มสินค้า",
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

  void showDialogsNoProduct(
    BuildContext context,
    String rawContent,
  ) {
    Alert(
      context: context,
      title: "ไม่พบสินค้า",
//      desc: "เงินทอน 0 บาท",
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
            "เพิ่มสินค้า",
            style: GoogleFonts.itim(color: Colors.black87),
          ),
          color: Colors.orange,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new addProducts(rawContent),
                ));
          },
        ),
      ],
    ).show();
  }

  void showDialogsHaveProduct(
    BuildContext context,
    String rawContent,
  ) {
    Alert(
      context: context,
      title: "มีรหัสสินค้านี้แล้ว",
//      desc: "เงินทอน 0 บาท",
      buttons: [
        DialogButton(
          child: Text(
            "ยืนยัน",
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

  _showDialogSelect(BuildContext context) {
    Alert(
      context: context,
      title: "ค้นหาสินค้า",
      desc: "",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                DialogButton(
                  child: Text(
                    "แสกนบาร์โค้ด",
                    style: GoogleFonts.itim(color: Colors.white),
                  ),
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.pop(context);
                    this.add(OpenScannerShowDetailExternalEvent(context));
                  },
                ),
              ])
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            "กรอกรหัสสินค้า",
            style: GoogleFonts.itim(color: Colors.white),
          ),
          color: Colors.orange,
          onPressed: () {
            Navigator.pop(context);
            _showDialogTextInput(context);
          },
        ),
      ],
    ).show();
  }

  _showDialogTextInput(BuildContext context) {
    TextEditingController _TextInputController = TextEditingController();
    Alert(
      context: context,
      title: "กรอกรหัสสินค้า",
      content: Form(
        child: Column(
          children: [
            TextFormField(
              controller: _TextInputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "ระบุรหัสสินค้า"),
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
            if (_TextInputController.text.length > 0) {
              /*_externalBloc.add(
                  TextInputExternalEvent(_TextInputController.text, context));

               */
              Navigator.pop(context);

              this.add(OpenTextSearchProductExternalEvent(
                  context, _TextInputController.text));
            }
          },
        ),
      ],
    ).show();
  }

  @override
  Stream<ExternalState> _decreaseProductPackToState(
      DecreaseProductPackExternalEvent event) async* {
    yield NormalExternalState(null,
        manageProduct: true,
        isCart: true,
        productPack: event.productPack.decreaseCount(),
        position: event.position);
  }

  @override
  Stream<ExternalState> _readTransitionToState(
      ReadTransitionExternalEvent event) async* {
    yield LoadingExternalState();
/*
    List<TransitionItem> list = await FirebaseCrudBloc().readingTransitionCRUD();

    yield ReadTransitionExternalState(list.reversed.toList(),null);


 */
  }

  @override
  Stream<ExternalState> _nowadaysReadTransitionToState(
      NowadaysReadTransitionExternalEvent event) async* {
    yield LoadingExternalState();


    List<TransitionModel> list = await FirebaseCrudBloc().readingNowadaysTransitionCRUD(date: event.date);

    yield NowadaysReadTransitionExternalState(list.reversed.toList());
  }

  @override
  Stream<ExternalState> _weekReadTransitionToState(
      WeekReadTransitionExternalEvent event) async* {
    yield LoadingExternalState();

    List<TransitionModel> list =
        await FirebaseCrudBloc().readingWeekTransitionCRUD();

    yield WeekReadTransitionExternalState(list.reversed.toList(), null);
  }

  @override
  Stream<ExternalState> _monthReadTransitionToState(
      MonthReadTransitionExternalEvent event) async* {
    yield LoadingExternalState();

    List<TransitionItem> list = await FirebaseCrudBloc()
        .readingMonthTransitionCRUD(event.month, event.year);


    yield MonthReadTransitionExternalState(list.reversed.toList(), null);
  }

  @override
  Stream<ExternalState> _yearReadTransitionToState(
      YearReadTransitionExternalEvent event) async* {
    yield LoadingExternalState();

    List<TransitionItem> list =
        await FirebaseCrudBloc().readingYearTransitionCRUD();

    list.forEach((element) {
      if (element.value != null) {
        print(element.value.createAt);

      }else {
        print(element.label);
        print(element.price);
      }
    });

    yield YearReadTransitionExternalState(list.reversed.toList(), null);
  }

  List<SalesData> _dayConvertSaleData(List<TransitionItem> list) {
    List<SalesData> saleList = [];
    double price = 0.00;
    String dateTimes = "";
    for (TransitionItem item in list) {
      if (item.label == null) {
        price += double.parse(item.value.price);
        dateTimes = item.value.createAt;
      } else {
        var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        DateTime dateTime = formatter.parse(dateTimes);

        saleList.add(SalesData("${dateTime.day}-${dateTime.month}", price));
        price = 0.00;
      }
    }

    return saleList;
  }

  List<SalesData> _monthConvertSaleData(List<TransitionItem> list) {
    List<SalesData> saleList = [];
    double price = 0.00;
    int count = 0;
    int month = 0;
    for (TransitionItem item in list) {
      count += 1;
      if (item.label != null) {
        if (count == list.length) {
          price += double.parse(item.price);
          saleList.add(SalesData("$month", price));
        } else {
          if (month == 0) {
            month = item.month;
            price = double.parse(item.price);
          } else if (item.month != month) {
            saleList.add(SalesData("$month", price));
            month = item.month;
            price = double.parse(item.price);
          } else {
            price += double.parse(item.price);
          }
        }
      }
    }

    return saleList;
  }

  @override
  Stream<ExternalState> _reportOutOfStockToState(
      ReportOutOfStockExternalEvent event) async* {
    yield LoadingExternalState();

    List<Product> list = await FirebaseCrudBloc().readingCRUD();

    List<Product> newList =
        list.where((element) => int.parse(element.quantity) == 0).toList();

    yield ReportOutOfStockExternalState(newList);
  }

  @override
  Stream<ExternalState> _chooseTypeToState(
      ChooseTypeExternalEvent event) async* {
    yield LoadingExternalState();

    if (event.isEdit) {
      yield EditExternalState(null, withType: event.type);
    } else {
      yield NormalExternalState(null, withType: event.type);
    }

    Navigator.pop(event.context);
  }

  @override
  Stream<ExternalState> _loadTypeToState(LoadTypeExternalEvent event) async* {
    yield LoadingExternalState();

    List<TypeModel> list = await FirebaseCrudBloc().readingTypeCRUD();

    list.addAll(TypeTool.DEFAULT_lIST);

    yield LoadTypeExternalState(list);
  }

  String _transitionDesInfo(List<CartModel> list) {
    String text = "";

    for (CartModel cart in list) {
      text +=
          "${cart.product.name} ${cart.product.size != null ? "(ขนาด ${cart.product.size}) " : ""}: ${cart.amount} ชิ้น\n";
    }

    return text;
  }

  _showTransitionDialog(BuildContext context, TransitionItem item,
      int tabPosition, ShopDetailModel shopDetailModel) {
    Alert(
      context: context,
      title: "รายละเอียด",
      desc:
          "ราคา: ${item.value.price} บาท\n${_transitionDesInfo(item.value.cart)}\n",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                DialogButton(
                  child: Text(
                    "ดูใบเสร็จ",
                    style: GoogleFonts.itim(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              new ReceiptPage(item, shopDetailModel),
                        ));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                DialogButton(
                  child: Text(
                    "ลบ",
                    style: GoogleFonts.itim(color: Colors.white),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                    FirebaseCrudBloc _firebaseCrud =
                        BlocProvider.of<FirebaseCrudBloc>(context);
                    _firebaseCrud.add(DeleteTransitionFirebaseCrudEvent(
                        context, item.value.id, tabPosition));
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                DialogButton(
                  child: Text(
                    "ปิด",
                    style: GoogleFonts.itim(color: Colors.black87),
                  ),
                  color: Colors.black12,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ])
        ],
      ),
      buttons: [],
    ).show();
  }

  @override
  Stream<ExternalState> _mapTransitionDialogToState(
      ShowTransitionDialogExternalEvent event) async* {
    ShopDetailModel shopDetailModel =
        await FirebaseCrudBloc().readingShopDetail();
    _showTransitionDialog(
        event.context, event.item, event.position, shopDetailModel);
  }
}
