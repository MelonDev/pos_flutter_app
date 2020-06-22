import 'package:flutter/material.dart';
import 'package:posflutterapp/components/product.dart';
import 'package:posflutterapp/page/page_add_products.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
//    final products = Provider.of<ProductsProvider>(context);

    print("building Products");
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(color: Colors.purple),
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Text(
          'คลังสินค้า',
          style: TextStyle(
              color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: new Column(
        children: <Widget>[
          Flexible(child: Products()),
        ],
      ),
//      new RefreshIndicator(
//        child: ListView.separated(
//          itemBuilder: (BuildContext context, int index) {
//            return ListTile(
//              leading: Image.network(
//                productNotifier.productList[index].images != null
//                    ? productNotifier.productList[index].images
//                    : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
//                width: 120,
//                fit: BoxFit.fitWidth,
//              ),
//              title: Text(productNotifier.productList[index].name),
//              subtitle: Text(productNotifier.productList[index].salePrice),
//              onTap: () {
//                productNotifier.currentProduct =
//                    productNotifier.productList[index];
//                Navigator.of(context)
//                    .push(MaterialPageRoute(builder: (BuildContext context) {
//                  return ProductDetail();
//                }));
//              },
//            );
//          },
//          itemCount: productNotifier.productList.length,
//          separatorBuilder: (BuildContext context, int index) {
//            return Divider(
//              color: Colors.black,
//            );
//          },
//        ),
//        onRefresh: _refreshList,
//      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "btn1",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return addProducts(
//                isUpdating: false,
                  );
            }),
          );
        },
        icon: Icon(Icons.add),
        label: Text("เพิ่มสินค้า"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.orange,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//      ),ListView(
//        margin: const EdgeInsets.only(left: 40, right: 40),
//        child: ClipRRect(
//          child: Column(
//        children: <Widget>[
//          new Padding(padding: const EdgeInsets.all(20)),
//          SizedBox(
//            height: 50,
//            child: Material(
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(18.0)),
//              color: Colors.orange, // button color
//              child: InkWell(
//                onTap: () => Navigator.of(context).push(new MaterialPageRoute(
//                    builder: (context) => new addProducts())), // button pressed
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Icon(
//                      Icons.add,
//                      color: Colors.white,
//                    ), // icon
//                    Text(
//                      "Add Product",
//                      style: TextStyle(color: Colors.white, fontSize: 18),
//                    ), // text
//                  ],
//                ),
//              ),
//            ),
//          ),
//          SizedBox(
//            height: 20,
//          ),
//
//        ],
//      ),
    );
//      ),
//    );
  }
}
