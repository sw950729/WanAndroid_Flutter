import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silence_flutter_study/common/Strings.dart';

/// @date:2020-01-20
/// @author:Silence
/// @describe:
class LoadMoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Center(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: new Text(Strings.inLoading))
          ],
        ),
      ),
    );
  }
}
