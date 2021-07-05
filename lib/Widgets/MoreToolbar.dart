import 'package:flutter/material.dart';

import 'kConst.dart';

class MoreToolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'جدید محصولات',
            style: kToolbarAll,
          ),
          Text('مشاهده همه >', style: kToolbarNew),
        ],
      ),
    );
  }
}
