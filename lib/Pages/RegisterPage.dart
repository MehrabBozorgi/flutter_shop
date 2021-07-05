import 'dart:convert' as convert;
import 'package:flutter_toplearn/Widgets/CircularWidget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_toplearn/Widgets/AppData.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String username, mobile, email, password;

  int send = 0;

  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'نام خانوادگی',
                    prefixIcon: Icon(Icons.person),
                  ),
                  initialValue: username,
                  onSaved: (String value) {
                    username = value;
                  },
                  validator: (String value) {
                    if (value.trim().length < 6) {
                      return 'نام و نام خانوادگی حداقل شامل 6 حرف باید باشد';
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'تلفن همراه',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  initialValue: mobile,
                  onSaved: (String value) {
                    mobile = value;
                  },
                  validator: (String value) {
                    if (!AppData.checkMobileNumber(value)) {
                      return 'شماره موبایل اشتباهه';
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ایمیل',
                    prefixIcon: Icon(Icons.email),
                  ),
                  initialValue: email,
                  onSaved: (String value) {
                    email = value;
                  },
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'ایمیل وارد کنید';
                    } else {
                      RegExp emailValidator = RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\'
                          r'.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                      if (!emailValidator.hasMatch(value)) {
                        return 'ایمیل معتبر نیست';
                      }
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'رمز عبور',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  initialValue: password,
                  onSaved: (String value) {
                    password = value;
                  },
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'کلمه علور را وارد منید';
                    } else if (value.trim().length < 6) {
                      return 'کلمه عبور کمتر از 6 حرف میباسد';
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (send == 0) {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        setState(() {
                          send = 1;
                        });

                        sendData();
                      }
                    }
                  },
                  child: send == 0 ? Text('Add') : CircularWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendData() {
    String url = AppData.server_url + '?action=register_user';

    http.post(url, body: {
      'username': username,
      'mobile': mobile,
      'email': email,
      'password': password,
    }).then((response) {
      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = convert.jsonDecode(response.body);

        if (data.containsKey('error')) {
          setState(() {
            send = 0;
            error = data['error'];
          });
        } else {
          //رفتن به صفحه دیگر

        }
      } else {
        send = 0;
        error = 'خطا در ارتباط با سرور - تلاش مجدد';
      }

      setState(() {
        send = 0;
        _formKey.currentState.reset();
      });
    });
  }
}
