import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/Strings.dart';

/// @date:2020-01-20
/// @author:Silence
/// @describe:
class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            'images/message_empty.png',
            width: 200.0,
            height: 200.0,
            fit: BoxFit.contain,
          )
        ],
      ),
    );
  }
}
