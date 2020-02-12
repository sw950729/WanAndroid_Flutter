import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/AppColors.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/common/Strings.dart';
import 'package:silence_wan_android/entity/HomeArticleListEntity.dart';
import 'package:silence_wan_android/entity/UserShareEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/widget/HomeListItemWidget.dart';
import 'package:silence_wan_android/widget/LoadMoreWidget.dart';
import 'package:silence_wan_android/widget/NoMoreWidget.dart';

/// @date:2020-02-11
/// @author:Silence
/// @describe:
class UserInfoPage extends StatelessWidget {
  final int userId;

  UserInfoPage({@required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.userInfoTitle),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: UserShareListPage(
        userId: userId,
      ),
    );
  }
}

class UserShareListPage extends StatefulWidget {
  final int userId;

  UserShareListPage({@required this.userId});

  @override
  _UserShareListPage createState() => _UserShareListPage();
}

class _UserShareListPage extends State<UserShareListPage> {
  var userName = Strings.textNull;
  var level = Strings.textNull;
  var ranking = Strings.textNull;
  var coinCount = Strings.textNull;
  var currentPage = 1;

  // 一页多少条
  static const PAGE_SIZE = 20;

  // 列表数据集合
  List<HomeArticleListDatasEntity> listData = List();

  // 是否加载更多
  bool isLoadMore = true;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  _UserShareListPage() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels) {
        _getUserInfo();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (DataUtils.listIsEmpty(listData)) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: AppColors.colorPrimary,
              width: double.infinity,
              height: 100.0,
              padding: EdgeInsets.only(bottom: 25.0, left: 10.0),
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
            ),
            Container(
              margin: EdgeInsets.only(top: 90.0),
              width: double.infinity,
              height: double.infinity,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: ListView.builder(
                itemBuilder: (context, i) => _createItem(i),
                itemCount: listData.length + 1,
              ),
            ),
          ],
        ),
      );
    }
  }

  _getUserInfo() {
    HttpUtils.getInstance().request(
        ApiUrl.userShareList +
            "${widget.userId}/share_articles/$currentPage/json", (data) {
      var userShareEntity = UserShareEntity.fromJson(data);
      setState(() {
        userName = userShareEntity.coinInfo.username;
        level = userShareEntity.coinInfo.level.toString();
        ranking = userShareEntity.coinInfo.rank.toString();
        coinCount = userShareEntity.coinInfo.coinCount.toString();
        if (userShareEntity.shareArticles.datas.length < PAGE_SIZE) {
          isLoadMore = false;
        }
        if (currentPage == 0) {
          listData.clear();
          listData.addAll(userShareEntity.shareArticles.datas);
        } else {
          listData.addAll(userShareEntity.shareArticles.datas);
        }
        currentPage++;
      });
    });
  }

  _createItem(int position) {
    if (!DataUtils.listIsEmpty(listData)) {
      if (position < listData.length) {
        return HomeListItemWidget(
          itemData: listData[position],
          isUserOwn: true,
        );
      } else if (position == listData.length) {
        if (isLoadMore) {
          return LoadMoreWidget();
        } else {
          return NoMoreWidget();
        }
      }
    }
    return null;
  }
}
