import 'package:flutter/material.dart';

class HomeViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeViewPage();
}

class _HomeViewPage extends State<HomeViewPage> {

  var listData = List();


  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
