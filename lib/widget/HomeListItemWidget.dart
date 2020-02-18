import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/AppColors.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/common/NavigationUtils.dart';
import 'package:silence_wan_android/common/SpUtils.dart';
import 'package:silence_wan_android/common/Strings.dart';
import 'package:silence_wan_android/entity/HomeArticleListEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/user/UserInfoPage.dart';
import 'package:silence_wan_android/user/login/LoginPage.dart';
import 'package:silence_wan_android/web/WebViewPage.dart';

/// @date:2020-01-20
/// @author:Silence
/// @describe:  首页列表数据
class HomeListItemWidget extends StatefulWidget {
  final HomeArticleListDatasEntity itemData;
  final bool isUserOwn;
  final String keyWord;

  HomeListItemWidget(
      {@required this.itemData, this.isUserOwn = false, this.keyWord = ""}) {
    this.itemData.title = DataUtils.replaceAll(this.itemData.title);
  }

  @override
  State<HomeListItemWidget> createState() => _HomeListItemWidget();
}

class _HomeListItemWidget extends State<HomeListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      //抗锯齿
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                  child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10.0),
                child: Text.rich(
                  DataUtils.isEmpty(widget.keyWord)
                      ? TextSpan(text: widget.itemData.title)
                      : DataUtils.getTextSpan(
                          widget.itemData.title, widget.keyWord),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              )),
              IconButton(
                alignment: Alignment.topRight,
                icon: Icon(
                  widget.itemData.collect
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.itemData.collect ? Colors.red : null,
                ),
                onPressed: () {
                  SpUtils.isLogin().then((isLogin) {
                    if (isLogin) {
                      if (widget.itemData.collect) {
                        _unCollect();
                      } else {
                        _collect();
                      }
                    } else {
                      _launchLogin();
                    }
                  });
                },
              ),
            ]),
            Container(
              padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(bottom: 5.0, right: 5.0),
                    child: Text(
                      widget.itemData.niceDate,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => (!widget.isUserOwn &&
                            DataUtils.isEmpty(widget.itemData.author))
                        ? _launchUserInfo(widget.itemData.userId)
                        : null,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(left: 10.0, bottom: 5.0),
                      child: Text(
                        DataUtils.isEmpty(widget.itemData.author)
                            ? Strings.shareUser + "${widget.itemData.shareUser}"
                            : Strings.authorWithString +
                                "${widget.itemData.author}",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: (!widget.isUserOwn &&
                                    DataUtils.isEmpty(widget.itemData.author))
                                ? AppColors.colorPrimary
                                : null),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        onTap: () {
          _onItemClick(widget.itemData);
        },
      ),
    );
  }

  void _onItemClick(itemData) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WebViewPage(
              webTitle: itemData.title,
              webUrl: itemData.link,
              collect: itemData.collect,
              articleId: itemData.id,
              isCanCollect: true,
            )));
  }

  _collect() {
    HttpUtils.getInstance()
        .request(ApiUrl.collect + "${widget.itemData.id}/json", (data) {
      setState(() {
        widget.itemData.collect = true;
      });
    }, method: HttpUtils.POST);
  }

  _unCollect() {
    HttpUtils.getInstance()
        .request(ApiUrl.unCollect + "${widget.itemData.id}/json", (data) {
      setState(() {
        widget.itemData.collect = false;
      });
    }, method: HttpUtils.POST);
  }

  // 跳转到登录
  _launchLogin() {
    SpUtils.isLogin().then((isLogin) async {
      if (!isLogin) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  _launchUserInfo(int userGuid) {
    NavigationUtils.pushPage(context, UserInfoPage(userId: userGuid));
  }
}
