import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/AppColors.dart';
import 'package:silence_wan_android/common/ConfigInfo.dart';
import 'package:silence_wan_android/common/SpUtils.dart';
import 'package:silence_wan_android/common/Store.dart';
import 'package:silence_wan_android/main/home/HomeViewPage.dart';
import 'package:silence_wan_android/main/home/MineViewPage.dart';
import 'package:silence_wan_android/main/home/NavigationViewPage.dart';
import 'package:silence_wan_android/main/home/ProjectViewPage.dart';

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
  var appBarTitles = [
    Strings.homePageTitle,
    Strings.navigationTitle,
    Strings.project,
    Strings.mine
  ];
  var _body;

  @override
  void initState() {
    super.initState();
    _navigationViews = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        title: Text(appBarTitles[0]),
        backgroundColor: AppColors.colorPrimary,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.widgets),
        title: Text(appBarTitles[1]),
        backgroundColor: AppColors.colorPrimary,
      ),
      BottomNavigationBarItem(
          icon: const Icon(Icons.apps),
          title: Text(appBarTitles[2]),
          backgroundColor: AppColors.colorPrimary),
      BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          title: Text(appBarTitles[3]),
          backgroundColor: AppColors.colorPrimary),
    ];
  }

  void initData() {
    _body = IndexedStack(
      children: <Widget>[
        HomeViewPage(),
        NavigationViewPage(),
        ProjectViewPage(),
        MineViewPage()
      ],
      index: _tabIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    initData();
    SpUtils.getTheme().then((position) {
      Store.value<ConfigModel>(context)
          .$setTheme(AppColors.themeList[position]);
    });
    return Store.connect<ConfigModel>(builder: (context, child, model) {
      return MaterialApp(
        theme: ThemeData(primaryColor: model.theme, accentColor: model.theme),
        home: Scaffold(
          body: _body,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
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
    });
  }
}
