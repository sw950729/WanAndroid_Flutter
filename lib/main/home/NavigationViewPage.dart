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
  List<Widget> pageViewList = <Widget>[
    NavigationListPage(),
    SystemListPage(),
    SquareListPage()
  ];
  PageController _pageController = PageController(initialPage: 0);
  var isPageCanChanged = true;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        index = _tabController.index;
      });
      if (_tabController.indexIsChanging) {
        onPageChange(_tabController.index, p: _pageController);
      }
    });
  }

  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      //判断是哪一个切换
      isPageCanChanged = false;
      await _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease); //等待pageview切换完毕,再释放pageivew监听
      isPageCanChanged = true;
    } else {
      _tabController.animateTo(index); //切换Tabbar
    }
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
      body: PageView.builder(
        itemCount: pageViewList.length,
        itemBuilder: (BuildContext context, int index) {
          return pageViewList[index];
        },
        onPageChanged: (index) {
          //由于pageview切换是会回调这个方法,又会触发切换tabbar的操作,所以定义一个flag,控制pageview的回调
          if (isPageCanChanged) {
            onPageChange(index);
          }
        },
        controller: _pageController,
      ),
    );
  }
}
