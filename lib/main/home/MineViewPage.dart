import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/common/SpUtils.dart';
import 'package:silence_wan_android/common/Strings.dart';
import 'package:silence_wan_android/entity/MineItemEntity.dart';
import 'package:silence_wan_android/entity/UserInfoEntity.dart';
import 'package:silence_wan_android/login/LoginPage.dart';
import 'package:silence_wan_android/mine/AboutMinePage.dart';
import 'package:silence_wan_android/mine/IntegralRecordPage.dart';
import 'package:silence_wan_android/mine/MyCollectPage.dart';
import 'package:silence_wan_android/mine/MyShareArticlePage.dart';
import 'package:silence_wan_android/mine/SystemSettingPage.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/web/WebViewPage.dart';
import 'package:silence_wan_android/widget/MineItemWidget.dart';

import '../../common/AppColors.dart';

/// @date:2020-01-14
/// @author:Silence
/// @describe:
class MineViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MineViewPage();
}

class _MineViewPage extends State<MineViewPage> {
  var ranking = Strings.textNull;
  var coinCount = Strings.textNull;
  var userName = Strings.noLogin;
  var level = Strings.textNull;
  var mineList = List<MineItemEntity>();

  @override
  void initState() {
    super.initState();
    MineItemEntity coinCountHistory = MineItemEntity(
        leftIconData: 'images/coin_count.png', title: Strings.coinCountHistory);
    MineItemEntity myCollect = MineItemEntity(
        leftIconData: 'images/collect.png', title: Strings.myCollect);
    MineItemEntity article = MineItemEntity(
        leftIconData: 'images/article.png', title: Strings.myShareArticle);
    MineItemEntity web = MineItemEntity(
        leftIconData: 'images/web.png', title: Strings.openSourceUrl);
    MineItemEntity setting = MineItemEntity(
        leftIconData: 'images/setting.png', title: Strings.systemSetting);
    MineItemEntity aboutMine = MineItemEntity(
        leftIconData: 'images/about_mine.png', title: Strings.aboutMine);
    MineItemEntity logout = MineItemEntity(
        leftIconData: 'images/logout.png', title: Strings.logout);
    mineList.add(coinCountHistory);
    mineList.add(myCollect);
    mineList.add(article);
    mineList.add(web);
    mineList.add(aboutMine);
    mineList.add(setting);
    mineList.add(logout);
    SpUtils.isLogin().then((isLogin) {
      if (isLogin) {
        _getUserInfo();
        SpUtils.getUserName().then((userName) {
          this.userName = userName;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GestureDetector(
              onTap: _launchLogin,
              child: Container(
                color: AppColors.colorPrimary,
                width: double.infinity,
                height: 200.0,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: CircleAvatar(
                        radius: 35.0,
                        backgroundImage: AssetImage('images/header_logo.jpg'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              userName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.white),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 15.0),
                                child: Text(
                                  Strings.level + "$level",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15.0, left: 10.0),
                                child: Text(
                                  Strings.ranking + "$ranking",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15.0, left: 10.0),
                                child: Text(
                                  Strings.coinCountWithString + "$coinCount",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
          Container(
            margin: EdgeInsets.only(top: 180.0),
            width: double.infinity,
            height: double.infinity,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child: ListView.builder(
              itemBuilder: (context, i) => _createItem(i),
              itemCount: mineList.length,
            ),
          ),
        ],
      ),
    );
  }

  // 跳转到登录
  _launchLogin() {
    SpUtils.isLogin().then((isLogin) async {
      if (!isLogin) {
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginPage()))
            .then((result) {
          if (!DataUtils.isEmpty(result)) {
            userName = result;
            _getUserInfo();
          }
        });
      }
    });
  }

  // 登录成功后获取用户信息
  void _getUserInfo() {
    HttpUtils.getInstance().request(ApiUrl.userInfo, (data) {
      setState(() {
        UserInfoEntity userInfoEntity = UserInfoEntity.fromJson(data);
        ranking = userInfoEntity.rank.toString();
        coinCount = userInfoEntity.coinCount.toString();
        level = "Lv " + userInfoEntity.level.toString();
      });
    });
  }

  // 跳转到积分记录
  _launchCoinCountHistory() {
    SpUtils.isLogin().then((isLogin) async {
      if (!isLogin) {
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginPage()))
            .then((result) {
          if (!DataUtils.isEmpty(result)) {
            userName = result;
            _getUserInfo();
          }
        });
      } else {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => IntegralRecordPage()));
      }
    });
  }

  // 跳转到我的收藏
  _launchMyCollect() {
    SpUtils.isLogin().then((isLogin) async {
      if (!isLogin) {
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginPage()))
            .then((result) {
          if (!DataUtils.isEmpty(result)) {
            userName = result;
            _getUserInfo();
          }
        });
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MyCollectPage()));
      }
    });
  }

  // 跳转到我的文章
  _launchMyShareArticle() {
    SpUtils.isLogin().then((isLogin) async {
      if (!isLogin) {
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginPage()))
            .then((result) {
          if (!DataUtils.isEmpty(result)) {
            userName = result;
            _getUserInfo();
          }
        });
      } else {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MyShareArticlePage()));
      }
    });
  }

  // 跳转到开源主页
  void _gotoWebPage() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WebViewPage(
              webTitle: Strings.wanAndroid,
              webUrl: ApiUrl.baseUrl,
              isCanCollect: false,
            )));
  }

  // 跳转到关于我们
  void _launchAboutMe() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AboutMinePage()));
  }

  // 跳转到系统设置
  void _launchSystemSetting() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SystemSettingPage()));
  }

  // 退出登录
  void _logout() {
    SpUtils.isLogin().then((isLogin) async {
      if (!isLogin) {
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginPage()))
            .then((result) {
          if (!DataUtils.isEmpty(result)) {
            userName = result;
            _getUserInfo();
          }
        });
      } else {
        HttpUtils.getInstance().request(ApiUrl.logout, (data) {
          setState(() {
            ranking = Strings.textNull;
            coinCount = Strings.textNull;
            userName = Strings.noLogin;
            level = Strings.textNull;
            Fluttertoast.showToast(msg: Strings.logoutSuccess);
            SpUtils.clearLoginInfo();
          });
        });
      }
    });
  }

  Widget _createItem(int position) {
    return GestureDetector(
      onTap: () {
        switch (position) {
          case 0:
            _launchCoinCountHistory();
            break;
          case 1:
            _launchMyCollect();
            break;
          case 2:
            _launchMyShareArticle();
            break;
          case 3:
            _gotoWebPage();
            break;
          case 4:
            _launchAboutMe();
            break;
          case 5:
            _launchSystemSetting();
            break;
          case 6:
            _logout();
            break;
        }
      },
      child: MineItemWidget(
        iconData: Image.asset(
          mineList[position].leftIconData,
          width: 30.0,
          height: 30.0,
        ),
        title: mineList[position].title,
      ),
    );
  }
}
