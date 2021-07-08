import 'package:flutter/material.dart';
import 'package:flutter_toplearn/Widgets/AppData.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../Model/appSlider.dart';

class HomeSlider extends StatefulWidget {
  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  List<AppSlider> slider = [];
  int sliderPosition = 0;

  getSlider() async {
    if (slider.length == 0) {
      var url = AppData.server_url + '?action=get_sliders';

      await http.get(url).then((response) {
        print(response.statusCode);

        if (response.statusCode == 200) {
          List jsonResponse = convert.jsonDecode(response.body);

          for (int i = 0; i < jsonResponse.length; i++) {
            setState(() {
              slider.add(
                new AppSlider(
                  id: int.parse(jsonResponse[i]['id']),
                  img_url: jsonResponse[i]['img_url'],
                ),
              );
            });
          }
        }
      });
    }
  }

  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    getSlider();

    return Container(
      height: 230,
      child: slider.length > 0
          ? Stack(
              children: [
                PageView.builder(
                  itemBuilder: (context, position) {
                    return Image(
                      image: NetworkImage(slider[position].img_url),
                      fit: BoxFit.fitWidth,
                    );
                  },
                  itemCount: slider.length,
                  onPageChanged: (position) {
                    setState(() {
                      sliderPosition = position;
                    });
                  },
                ),
                Container(
                  margin: EdgeInsets.only(top: 220),
                  child: Center(
                    child: slider_Footer(),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _Active() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      width: 10,
      height: 10,
    );
  }

  // ignore: non_constant_identifier_names
  Widget _InActive() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      width: 10,
      height: 10,
    );
  }

  Widget slider_Footer() {
    List<Widget> sliderItem = [];

    for (int i = 0; i < slider.length; i++) {
      i == sliderPosition
          ? sliderItem.add(_Active())
          : sliderItem.add(_InActive());
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: sliderItem,
    );
  }
//
}
