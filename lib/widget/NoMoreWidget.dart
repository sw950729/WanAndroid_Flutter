import 'package:flutter/material.dart';
import 'package:silence_flutter_study/common/Strings.dart';

class NoMoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Center(
        child: Text(
          Strings.noMoreData,
        ),
      ),
    );
  }
}
