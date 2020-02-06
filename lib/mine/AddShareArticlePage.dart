import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/AppColors.dart';
import 'package:silence_wan_android/common/Strings.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';

/// @date:2020-01-29
/// @author:Silence
/// @describe:
class AddShareArticlePage extends StatefulWidget {
  @override
  _AddShareArticlePageState createState() => _AddShareArticlePageState();
}

class _AddShareArticlePageState extends State<AddShareArticlePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.shareArticle),
        centerTitle: true,
      ),
      key: scaffoldKey,
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              Strings.title,
              style: TextStyle(fontSize: 12.0, color: AppColors.color999999),
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: Strings.articleTitle,
                contentPadding: const EdgeInsets.all(10.0),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text(
                Strings.link,
                style: TextStyle(fontSize: 12.0, color: AppColors.color999999),
              ),
            ),
            TextFormField(
              controller: _linkController,
              decoration: InputDecoration(
                hintText: Strings.articleLink,
                contentPadding: const EdgeInsets.all(10.0),
              ),
            ),
            Container(
                height: 40.0,
                margin: EdgeInsets.only(top: 25.0),
                width: double.infinity,
                child: RaisedButton(
                  child: Text(Strings.share),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    _shareArticle();
                  },
                ))
          ],
        ),
      ),
    );
  }

  void _shareArticle() async {
    if (_titleController.text.length == 0) {
      showToast(Strings.pleaseInputShareArticleTitle);
      return;
    }
    if (_linkController.text.length == 0) {
      showToast(Strings.pleaseInputShareArticleLink);
      return;
    }
    HttpUtils.getInstance().request(ApiUrl.shareArticle, (responseData) {
      showToast(Strings.shareSuccess);
      _titleController.clear();
      _linkController.clear();
    }, method: HttpUtils.POST, requestData: {
      'title': _titleController.text,
      'link': _linkController.text
    });
  }

  void showToast(String msg) {
    final snackBar = new SnackBar(
      content: new Text(msg),
      backgroundColor: Colors.teal,
      duration: Duration(seconds: 2),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
