import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_toplearn/Widgets/AppData.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class CommentPage extends StatefulWidget {
  int product_id;

  CommentPage(this.product_id);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _comment = '';

  int send = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ثبت نظرات'),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(right: 10, left: 10, top: 20),
                      child: TextFormField(
                        onSaved: (String value) {
                          _name = value;
                        },
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'فیلد مورد نظر را پر کنید';
                          }
                        },
                        keyboardType: TextInputType.name,
                        maxLength: 20,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.red,
                          ),
                          labelText: 'نام و نام خانوادگی',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.only(right: 10, left: 10),
                      child: TextFormField(
                        onSaved: (String value) {
                          _email = value;
                        },
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'فیلد مورد نظر را پر کنید';
                          }
                        },
                        maxLength: 30,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.red,
                          ),
                          labelText: 'ایمیل',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 30, right: 20, left: 20, bottom: 20),
                      child: TextFormField(
                        onSaved: (String value) {
                          _comment = value;
                        },
                        validator: (String value) {
                          if (value.trim().isEmpty) {
                            return 'فیلد مورد نظر را پر کنید';
                          }
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 5,
                        maxLength: 400,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.red,
                          ),
                          labelText: 'نظر شما',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    ButtonTheme(
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            //با استفاده save خودش میفهمه که باید متد رو سیو کنه
                            _formKey.currentState.save();

                            setState(() {
                              send = 1;
                            });
                            sendCommentData();
                          }
                        },
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Text('ثبت نظر'),
                      ),
                      height: 50,
                      minWidth: MediaQuery.of(context).size.width - 30,
                    )
                  ],
                ),
              ),
            ),
          ),
          //برای وقتیه که نظ رو ثبت میکنیمنیم اون بچزخه
          send == 1
              ? Opacity(
                  opacity: 0.3,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : Text(''),
        ],
      ),
    );
  }

  sendCommentData() {
    String url = AppData.server_url +
        '?action=add_comment&product_id=' +
        widget.product_id.toString();
    http.post(url, body: {
      'name': _name,
      'email': _email,
      'comment': _comment,
    }).then((response) {
      print(response.body);

      setState(() {
        send = 0;
        _formKey.currentState.reset();
      });
    });
  }
}
