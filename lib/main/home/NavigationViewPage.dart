import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/NavigationUtils.dart';
import 'package:silence_wan_android/common/Strings.dart';
import 'package:silence_wan_android/mine/AddShareArticlePage.dart';
import 'package:silence_wan_android/navigation/NavigationListPage.dart';
import 'package:silence_wan_android/navigation/SquareListPage.dart';
import 'package:silence_wan_android/navigation/SystemListPage.dart';

/// @date:2020-01-14
/// @author:Silence
/// @describe:
class NavigationViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationViewPage();
}

class _NavigationViewPage extends State<NavigationViewPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var index = 1;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        index = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TabBar(
          controller: this._tabController,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white,
          labelColor: Colors.white,
          tabs: <Widget>[
            Tab(
              text: Strings.navigationTitle,
            ),
            Tab(
              text: Strings.systemTitle,
            ),
            Tab(
              text: Strings.squareTitle,
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Visibility(
              child: Icon(Icons.add),
              visible: index == 2,
            ),
            onPressed: () {
              NavigationUtils.pushPage(context, AddShareArticlePage(),
                  needLogin: true);
            },
          )
        ],
      ),
      body: TabBarView(
        controller: this._tabController,
        children: <Widget>[
          NavigationListPage(),
          SystemListPage(),
          SquareListPage()
        ],
      ),
    );
  }
}
