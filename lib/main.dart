import 'package:flutter_toplearn/Pages/CartPage.dart';
import 'package:flutter_toplearn/Pages/RegisterPage.dart';
import 'Pages/FirstPage.dart';
import 'package:flutter/material.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MainPage()));

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 100),
            child: Column(
              children: [
                ListTile(
                  title: Text('ورود'),
                  onTap: () {},
                ),
                Container(
                  child: ListTile(
                    autofocus: true,
                    selected: true,
                    title: Text('ثبت نام'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => RegisterPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('فروشگاه'),
          elevation: 10,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CartPage()),
                  );
                }),
          ],
        ),
        // backgroundColor: Colors.green,
        body: SafeArea(
          child: FirstPage(),
        ),
      ),
    );
  }
}
