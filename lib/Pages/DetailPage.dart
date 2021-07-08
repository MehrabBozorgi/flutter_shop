import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_toplearn/Pages/Cart.dart';
import 'package:flutter_toplearn/Widgets/CircularWidget.dart';
import 'CartPage.dart';
import 'ShowCommentsPage.dart';
import 'file:///F:/AndroidStudioProjects/Flutter/flutter_toplearn/lib/Widgets/AppData.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  int product_id;
  String product_title;

  DetailPage(int id, String title) {
    product_id = id;
    product_title = title;
  }

  @override
  _DetailPageState createState() => _DetailPageState(product_id);
}

class _DetailPageState extends State<DetailPage> {
  String title = '';
  String img_url = '';
  String description = '';

  String price;

  String productPrice;

  int tab_index = 0;

  _DetailPageState(product_id) {
    String url = AppData.server_url +
        '?action=getProductData&id=' +
        product_id.toString();

    http.get(url).then((response) {
      dynamic jsonResponse = convert.jsonDecode(response.body);

      setState(() {
        title = jsonResponse['title'];
        img_url = jsonResponse['img_url'];
        description = jsonResponse['description'];
        productPrice = jsonResponse['price'];

        var format = new NumberFormat('###,###');
        price = format.format(int.parse(jsonResponse['price'])).toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.red,
        title: Text(
          widget.product_title,
          style: TextStyle(fontSize: 14),
        ),
      ),

      /////////////////////////////////////////////////
      body: (_childern(tab_index)),
      //////////////////////////////////////////////////
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        elevation: 5,
        selectedItemColor: Colors.white,
        showSelectedLabels: true,
        mouseCursor: MouseCursor.defer,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.title), label: 'توضیحات'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'نطرات'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'گالری'),
        ],
        onTap: (index) {
          setState(() {
            tab_index = index;
          });
        },
        currentIndex: tab_index,
      ),
    );
  }

  Widget _childern(index) {
    List<Widget> pageScreen = [];

    pageScreen.add(_tozihatScreen());
    pageScreen.add(_commentScreen());
    pageScreen.add(_GalleryScreen());

    return pageScreen[index];
  }

  Widget _tozihatScreen() {
    double w = MediaQuery.of(context).size.width - 50;

    return (title.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image(
                    image: NetworkImage(img_url),
                    height: 200,
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  margin:
                      EdgeInsets.only(top: 20, bottom: 10, right: 15, left: 15),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  margin:
                      EdgeInsets.only(top: 15, bottom: 10, right: 15, left: 15),
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                //////////////////////////////////////
                /////// دکمه اضافه کردن به سبد خرید
                //////////////////////////////////////
                GestureDetector(
                  onTap: () {
                    Cart.add_product_cart(widget.product_id.toString(), title,
                            int.parse(productPrice), img_url)
                        .then((response) {
                      if (response) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartPage()),
                        );
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green,
                    ),
                    margin: EdgeInsets.only(bottom: 20, top: 20),
                    width: w,
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            price + ' تومان',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Icon(Icons.shopping_cart)
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        : CircularWidget());
  }

  Widget _commentScreen() {
    return ShowCommentsPage(widget.product_id);
  }

  Widget _GalleryScreen() {
    return Container(
      child: Center(
        child: Text('Gallery'),
      ),
    );
  }
}
