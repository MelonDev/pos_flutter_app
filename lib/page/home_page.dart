import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posflutterapp/bloc/authentication/authentication_bloc.dart';
import 'package:posflutterapp/page/page_add_type_product.dart';
import 'package:posflutterapp/page/page_products.dart';
import 'package:posflutterapp/page/page_report.dart';
import 'package:posflutterapp/page/report_today_page.dart';
import 'package:posflutterapp/page/setting_page.dart';
import 'package:posflutterapp/services/functions.dart';

import '../user_repository.dart';
import 'cart.dart';

class HomePage extends StatelessWidget {
  final UserRepository _userRepository;

  HomePage({Key key, @required UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

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
            SizedBox(
              height: 56,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      "POS SHOP",
                      style: GoogleFonts.itim(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
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
        margin: const EdgeInsets.only(left: 40, right: 40),
//          mainAxisAlignment: MainAxisAlignment.center,

        child: ClipRRect(
          child: ListView(
            children: <Widget>[
              new Padding(padding: const EdgeInsets.all(20)),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  color: Colors.purple, // button color
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (context) =>
                                new Cart())), // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 100,
                        ), // icon
                        Text(
                          "ขายสินค้า",
                          style: GoogleFonts.itim(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ), // text
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  color: Colors.purple, // button color
                  child: InkWell(
                    onTap: () {
                      changeScreen(context, ProductsPage());
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.dashboard,
                          color: Colors.white,
                          size: 100,
                        ), // icon
                        Text(
                          "คลังสินค้า",
                          style: GoogleFonts.itim(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ), // text
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  color: Colors.purple, // button color
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (context) =>
                                new ReportTodayPage())), // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.description,
                          color: Colors.white,
                          size: 100,
                        ), // icon
                        Text(
                          "รายงาน",
                          style: GoogleFonts.itim(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ), // text
                      ],
                    ),
                  ),
                ),
              ),
              /*SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  color: Colors.purple, // button color
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (context) =>
                            new PageAddTypeProduct(isPage: true,isEdit: false,))), // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.line_weight,
                          color: Colors.white,
                          size: 100,
                        ), // icon
                        Text(
                          "ประเภทสินค้า",
                          style: GoogleFonts.itim(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ), // text
                      ],
                    ),
                  ),
                ),
              ),

               */
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  color: Colors.purple, // button color
                  child: InkWell(
                    onTap: () {
                      /*BlocProvider.of<AuthenticationBloc>(context).add(
                        AuthenticationLoggedOut(),
                      );

                       */
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => new SettingPage()));
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 100,
                        ), // icon
                        Text(
                          "ตั้งค่า",
                          style: GoogleFonts.itim(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ), // text
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
