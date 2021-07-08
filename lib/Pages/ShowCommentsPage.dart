import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_toplearn/Widgets/AppData.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'CommentPage.dart';

class ShowCommentsPage extends StatefulWidget {
  int productId;

  ShowCommentsPage(this.productId);

  @override
  _ShowCommentsPageState createState() => _ShowCommentsPageState(productId);
}

class _ShowCommentsPageState extends State<ShowCommentsPage> {
  List<dynamic> commentList = [];

  _ShowCommentsPageState(productId) {
    if (commentList.length == 0) {
      String url = AppData.server_url +
          '?action=get_comment&product_id=' +
          productId.toString();

      http.get(url).then((response) {
        if (response.statusCode == 200) {
          print('کار کرد ...');
          setState(() {
            commentList = convert.jsonDecode(response.body);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return CommentDesign(index);
          },
          itemCount: commentList.length,
          scrollDirection: Axis.vertical,
        ),
        floatButton(),
      ],
    );
  }

  Widget CommentDesign(int index) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[400],
          ),
          color: Colors.grey[200]),
      margin: EdgeInsets.only(right: 10, left: 10, top: 20),
      child: Column(
        children: [
          Text(
            'ارسال شده از :  ' + commentList[index]['name'],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            color: Colors.white,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Text(
              commentList[index]['content'],
            ),
          ),
        ],
      ),
    );
  }

  Widget floatButton() {
    return Positioned(
      bottom: 10,
      right: 15,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    CommentPage(widget.productId),
              ));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        elevation: 5,
        mouseCursor: MouseCursor.defer,
        focusElevation: 5,
        splashColor: Colors.red[900],
        backgroundColor: Colors.red,
      ),
    );
  }
}
