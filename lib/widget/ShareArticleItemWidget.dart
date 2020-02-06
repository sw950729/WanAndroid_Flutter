import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:silence_wan_android/common/AppColors.dart';
import 'package:silence_wan_android/common/Strings.dart';
import 'package:silence_wan_android/entity/ShareArticleListEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/web/WebViewPage.dart';

/// @date:2020-01-29
/// @author:Silence
/// @describe:
class ShareArticleItemWidget extends StatefulWidget {
  final ShareArticleList shareArticleList;
  final ValueChanged<int> deleteArticle;
  final int position;

  ShareArticleItemWidget(
      {Key key, this.shareArticleList, this.position, this.deleteArticle})
      : super(key: key);

  @override
  _ShareArticleItemWidgetState createState() => _ShareArticleItemWidgetState();
}

class _ShareArticleItemWidgetState extends State<ShareArticleItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4.0,
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.shareArticleList.title,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Text(
                            widget.shareArticleList.niceShareDate,
                            style: TextStyle(
                                fontSize: 14.0, color: AppColors.color999999),
                          )),
                    ],
                  )),
              IconButton(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 10.0),
                icon: Icon(Icons.close),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          elevation: 4.0,
                          content: Text(Strings.makeSureDeleteArticle),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _deleteArticle();
                              },
                              child: new Text(Strings.makeSure),
                            ),
                            new FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: new Text(Strings.cancel),
                            ),
                          ],
                        );
                      });
                },
              )
            ],
          ),
          onTap: _onItemClick,
        ));
  }

  void _onItemClick() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WebViewPage(
              webTitle: widget.shareArticleList.title,
              webUrl: widget.shareArticleList.link,
              collect: widget.shareArticleList.collect,
              articleId: widget.shareArticleList.id,
              isCanCollect: true,
            )));
  }

  void _deleteArticle() {
    HttpUtils.getInstance()
        .request(ApiUrl.deleteArticle + "${widget.shareArticleList.id}/json",
            (responseData) {
      widget.deleteArticle(widget.position);
      Fluttertoast.showToast(msg: Strings.deleteSuccess);
    }, method: HttpUtils.POST);
  }
}
