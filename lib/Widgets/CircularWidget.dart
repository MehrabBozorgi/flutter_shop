import 'package:flutter/material.dart';

class CircularWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD1FD3F)),
        ),
      ),
    );
  }
}
