import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toplearn/Widgets/AppData.dart';
import 'package:flutter_toplearn/Widgets/CircularWidget.dart';
import 'package:flutter_toplearn/Widgets/MoreToolbar.dart';
import 'file:///F:/AndroidStudioProjects/Flutter/flutter_toplearn/lib/Widgets/SliderView.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../Model/product.dart';
import 'package:intl/intl.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<Product> new_product = [];
  List<Product> order_product = [];

  @override
  Widget build(BuildContext context) {
    getProduct('new_product', new_product);
    getProduct('order_product', order_product);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //PageView
            HomeSlider(),

            MoreToolbar(),
            SizedBox(
              height: 10,
            ),

            new_product.length > 0
                ? Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(right: 5, left: 5),
                    height: 250,
                    child: ListView.builder(
                      itemBuilder: NewProductList,
                      itemCount: new_product.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                : CircularWidget(),

            //////////////////////////  ORDER_PRODUCT  ////////////////////
            SizedBox(
              height: 20,
            ),
            MoreToolbar(),
            SizedBox(
              height: 10,
            ),

            order_product.length > 0
                ? Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(right: 5, left: 5),
                    height: 250,
                    child: ListView.builder(
                      itemBuilder: OrderProductList,
                      itemCount: order_product.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                : CircularWidget(),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }

//////////////////////////////////////////////////////////////////////

  getProduct(String action, List<Product> list) async {
    if (list.length == 0) {
      var url = AppData.server_url + '?action=' + action;

      await http.get(url).then((response) {
        if (response.statusCode == 200) {
          List jsonResponse = convert.jsonDecode(response.body);
          for (int i = 0; i < jsonResponse.length; i++) {
            setState(() {
              list.add(new Product(
                id: int.parse(jsonResponse[i]['id']),
                title: jsonResponse[i]['title'],
                price: int.parse(jsonResponse[i]['price']),
                img_url: jsonResponse[i]['img_url'],
                description: jsonResponse[i]['description'],
              ));
            });
          }
        }
      });
    }
  }

  Widget NewProductList(BuildContext context, int index) {
    return indexProductView(index, new_product);
  }

  Widget OrderProductList(BuildContext context, int index) {
    return indexProductView(index, order_product);
  }

/////////////////////////////////////////////////////////////////////////
  Widget indexProductView(int index, List<Product> list) {
    String price = '';
    var formatPatter = new NumberFormat('###,###');
    price = formatPatter.format(list[index].price);

    return Column(
      children: [
        Image(
          image: NetworkImage(list[index].img_url),
          height: 150,
        ),
        Text(list[index].title),
        Text(list[index].price.toString()),
      ],
    );
  }
}
