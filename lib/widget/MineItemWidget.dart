import 'package:flutter/material.dart';

class MineItemWidget extends StatefulWidget {
 final Widget iconData;
 final String title;

  @override
  State<StatefulWidget> createState() => _MineItemWidget();

  MineItemWidget({ this.iconData, this.title});
}

class _MineItemWidget extends State<MineItemWidget> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(top: 20.0),
      child: InkWell(
          child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 15.0),
            child: Row(
              children: <Widget>[
                widget.iconData,
                Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 10.0),
            child: Icon(
              Icons.chevron_right,
              size: 30.0,
            ),
          )
        ],
      )),
    );
  }
}
