import 'package:flutter/material.dart';
import 'package:silence_wan_android/entity/NavigationEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/widget/NavigationListItemWidget.dart';

/// @date:2020-02-12
/// @author:Silence
/// @describe: 顶部导航tab
class NavigationListPage extends StatefulWidget {
  @override
  _NavigationListPageState createState() => _NavigationListPageState();
}

class _NavigationListPageState extends State<NavigationListPage> {
  List<NavigationEntity> navigationList = List();

  @override
  void initState() {
    super.initState();
    _getNavigationList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, i) => _createItem(i),
      itemCount: navigationList.length,
    );
  }

  _getNavigationList() {
    HttpUtils.getInstance().request(ApiUrl.navigation, (response) {
      (response as List<dynamic>).forEach((v) {
        setState(() {
          navigationList.add(NavigationEntity.fromJson(v));
        });
      });
    });
  }

  Widget _createItem(int position) {
    return NavigationListItemWidget(
      navigationEntity: navigationList[position],
    );
  }
}
