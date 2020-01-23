import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silence_flutter_study/common/AppColors.dart';
import 'package:silence_flutter_study/main/home/HomeViewPage.dart';
import 'package:silence_flutter_study/main/home/MineViewPage.dart';
import 'package:silence_flutter_study/main/home/NavigationViewPage.dart';

import '../common/Strings.dart';

/// @date:2020-01-14
/// @author:Silence
/// @describe:
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  int _tabIndex = 0;
  List<BottomNavigationBarItem> _navigationViews;
  var appBarTitles = [Strings.homePageTitle, '导航', '我的'];
  var _body;

  @override
  void initState() {
    super.initState();
    _navigationViews = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        title: Text(appBarTitles[0]),
        backgroundColor: Colors.blue,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.widgets),
        title: Text(appBarTitles[1]),
        backgroundColor: Colors.blue,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person),
        title: Text(appBarTitles[2]),
        backgroundColor: Colors.blue,
      ),
    ];
  }

  void initData() {
    _body = IndexedStack(
      children: <Widget>[HomeViewPage(), NavigationViewPage(), MineViewPage()],
      index: _tabIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return MaterialApp(
      theme: ThemeData(
          primaryColor: AppColors.colorPrimary, accentColor: Colors.blue),
      home: Scaffold(
        body: _body,
        bottomNavigationBar: BottomNavigationBar(
          items: _navigationViews,
          currentIndex: _tabIndex,
          onTap: (index) {
            setState(() {
              _tabIndex = index;
            });
          },
        ),
      ),
    );
  }
}
