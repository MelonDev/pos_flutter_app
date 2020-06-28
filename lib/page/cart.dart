import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/bloc/external/external_bloc.dart';
import 'package:posflutterapp/bloc/firebase_crud/firebase_crud_bloc.dart';
import 'package:posflutterapp/bloc/firebase_products/firebase_products_bloc.dart';
import 'package:posflutterapp/components/cart_products.dart';
import 'package:posflutterapp/models/ProductPack.dart';
import 'package:posflutterapp/models/ProductPackDuplicate.dart';
import 'package:posflutterapp/models/products_models.dart';
import 'package:posflutterapp/page/page_add_products.dart';
import 'package:posflutterapp/page/page_products_details.dart';
import 'package:posflutterapp/page/scanner_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  FirebaseCrudBloc _firebaseCrudBloc;

  List<ProductPack> _listProductPack = [];

  ExternalBloc _externalBloc;

  double _totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    _externalBloc = BlocProvider.of<ExternalBloc>(context);

    _firebaseCrudBloc = BlocProvider.of<FirebaseCrudBloc>(context);

/*    _image = _productPack.product.image != null
        ? (_productPack.product.image.length > 0 ? _productPack.product.image[0] : "")
        : "";

 */

    return BlocBuilder<ExternalBloc, ExternalState>(
      builder: (BuildContext context, _state) {
        if (_state is NormalExternalState) {
          if (_state.manageProduct != null) {
            if (_state.productPack.count > 0) {
              if (_state.outOfStock == null) {
                _listProductPack.removeAt(_state.position);
                _listProductPack.insert(_state.position, _state.productPack);
              }
            } else {
              _listProductPack.removeAt(_state.position);
            }
            _totalPrice = 0;
            for (ProductPack productPack in _listProductPack) {
              _totalPrice += (double.parse(productPack.product.salePrice) *
                      productPack.count)
                  .toDouble();
            }
          }
          if (_state.notfound != null) {
            if (_state.notfound) {
              print("GO TO NEW PRODUCT");
//addProducts(_state.barcode);
            } else {
              List<ProductPackDuplicate> duplicateList = [];
              for (int i = 0; i < _listProductPack.length; i++) {
                if (_listProductPack[i]
                    .product
                    .serialNumber
                    .contains(_state.productPack.product.serialNumber)) {
                  duplicateList.add(ProductPackDuplicate()
                      .initialProductPack(_listProductPack[i], i));
                }
              }

              if (duplicateList.length > 0) {
                _externalBloc.add(IncreaseProductPackExternalEvent(
                    duplicateList[0].productPack,
                    duplicateList[0].position,
                    this.context));
              } else {
                if (_state.outOfStock == null) {
                  _listProductPack.add(_state.productPack);
                  _totalPrice +=
                      double.parse(_state.productPack.product.salePrice);
                }
              }
            }
          }
        }
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
                                Icons.arrow_back,
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
                                _externalBloc.add(InitialExternalEvent());
                                _firebaseCrudBloc.add(
                                    StartTransitionFirebaseCrudEvent(
                                        _listProductPack,
                                        _totalPrice,
                                        this.context));
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
          body: ListView.builder(
            itemCount: _listProductPack.length ?? 0,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  color: Colors.green,
                  width: double.infinity,
                  height: 120,
                  child: Hero(
                    tag: new Text("hero1"),
                    child: Material(
                      child: Container(
                        width: double.infinity,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              child: Container(
                                height: 120,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 100,
                                      alignment: Alignment.centerLeft,
                                      //color: Color(0x40000000),
                                      child: _listProductPack[index]
                                                  .product
                                                  .image
                                                  .length >
                                              0
                                          ? Container(
                                              height: 120,
                                              child: Image.network(
                                                _getImage(
                                                    _listProductPack[index]
                                                        .product),
                                                fit: BoxFit.fitHeight,
                                              ),
                                            )
                                          : Container(),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          100 -
                                          50 -
                                          100,
                                      //color: Color(0x40000000),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Text(
                                          _listProductPack[index]
                                                  .product
                                                  .name ??
                                              "",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 4,
                                          style: GoogleFonts.itim(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 90,
                                      color: Colors.white,
                                      child: Container(
                                        child: Text(
                                          "${_listProductPack[index].product.salePrice}" +
                                                  " ฿" ??
                                              "",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: GoogleFonts.itim(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      alignment: Alignment.centerRight,
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          new IconButton(
                                            icon: Icon(Icons.arrow_drop_up),
                                            onPressed: () {
                                              _externalBloc.add(
                                                  IncreaseProductPackExternalEvent(
                                                      _listProductPack[index],
                                                      index,
                                                      this.context));
                                            },
                                          ),
                                          new Text(
                                            _listProductPack[index]
                                                .count
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                          new IconButton(
                                            icon: Icon(Icons.arrow_drop_down),
                                            onPressed: () {
                                              _externalBloc.add(
                                                  DecreaseProductPackExternalEvent(
                                                      _listProductPack[index],
                                                      index,
                                                      this.context));
                                            },
                                          ),
                                        ],
                                      ),
                                    )
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
              );
            },
          ),
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
                                  "${_totalPrice.toStringAsFixed(2)} ฿",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.itim(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _externalBloc
                                .add(OpenScannerOnCartExternalEvent(context));
                          },
                          child: Container(
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getImage(Product product) {
    return product.image != null
        ? (product.image.length > 0 ? product.image[0] : "")
        : "";
  }
}
//class Single_cart_product extends StatelessWidget {
//  final ProductPack _productPack;
//  String _image;
//
//  Single_cart_product(this._productPack);
//
//  @override
//  Widget build(BuildContext context) {
//    _image = _productPack.product.image != null
//        ? (_productPack.product.image.length > 0 ? _productPack.product.image[0] : "")
//        : "";
//
//    return Container(
//      color: Colors.green,
//      width: double.infinity,
//      height: 120,
//      child: Hero(
//        tag: new Text("hero1"),
//        child: Material(
//          child: InkWell(
//            onTap: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => ProductDetail(_productPack.product),
//                ),
//              );
//            },
//            child: Container(
//              width: double.infinity,
//              child: Stack(
//                children: <Widget>[
//                  Align(
//                    child: Container(
//                      height: 120,
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: [
//                          Container(
//                            width: 100,
//                            alignment: Alignment.centerLeft,
//                            //color: Color(0x40000000),
//                            child: _image.length > 0
//                                ? Container(
//                              height: 120,
//                              child: Image.network(
//                                _image,
//                                fit: BoxFit.fitHeight,
//                              ),
//                            )
//                                : Container(),
//                          ),
//                          Container(
//                            width: MediaQuery.of(context).size.width -
//                                100 -
//                                50 -
//                                100,
//                            //color: Color(0x40000000),
//                            child: Container(
//                              alignment: Alignment.centerLeft,
//                              margin: EdgeInsets.only(left: 20, right: 20),
//                              child: Text(
//                                _productPack.product.name ?? "",
//                                overflow: TextOverflow.ellipsis,
//                                maxLines: 4,
//                                style: GoogleFonts.itim(
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 20,
//                                    color: Colors.black87),
//                              ),
//                            ),
//                          ),
//                          Container(
//                            width: 90,
//                            color: Colors.white,
//                            child: Container(
//                              child: Text(
//                                "${_productPack.product.salePrice}" + " ฿" ?? "",
//                                overflow: TextOverflow.ellipsis,
//                                maxLines: 1,
//                                style: GoogleFonts.itim(
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 20,
//                                    color: Colors.black87),
//                              ),
//                            ),
//                          ),
//                          Container(
//                            width: 50,
//                            alignment: Alignment.centerRight,
//                            color: Colors.white,
//                            child: Column(
//                              children: <Widget>[
//                                new IconButton(
//                                  icon: Icon(Icons.arrow_drop_up),
//                                  onPressed: () {},
//                                ),
//                                new Text(
//                                  _productPack.count.toString(),
//                                  style: TextStyle(
//                                      color: Colors.black,
//                                      fontWeight: FontWeight.w500,
//                                      fontSize: 16),
//                                ),
//                                new IconButton(
//                                  icon: Icon(Icons.arrow_drop_down),
//                                  onPressed: () {},
//                                ),
//                              ],
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
