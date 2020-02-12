import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../common/DataUtils.dart';

/// @date:2020-01-20
/// @author:Silence
/// @describe: 共用的Web页面
class WebViewPage extends StatefulWidget {
  final String webUrl;
  final String webTitle;
  final bool collect;
  final bool isCanCollect;
  final int articleId;

  WebViewPage({
    @required this.webTitle,
    @required this.webUrl,
    this.collect = false,
    this.isCanCollect = true,
    this.articleId,
  });

  State<WebViewPage> createState() => _WebViewPage(collect: collect);
}

class _WebViewPage extends State<WebViewPage> {
  bool collect;

  _WebViewPage({this.collect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DataUtils.replaceAll(widget.webTitle)),
        centerTitle: true,
        actions: <Widget>[
          Visibility(
            visible: widget.isCanCollect,
            child: IconButton(
              icon: Icon(
                collect ? Icons.favorite : Icons.favorite_border,
                color: collect ? Colors.red : null,
              ),
              onPressed: () {
                if (collect) {
                  _unCollect();
                } else {
                  _collect();
                }
              },
            ),
          ),
        ],
      ),
      body: WebView(
          initialUrl: widget.webUrl,
          javascriptMode: JavascriptMode.unrestricted),
    );
  }

  _collect() {
    HttpUtils.getInstance().request(ApiUrl.collect + "${widget.articleId}/json",
        (data) {
      setState(() {
        collect = true;
      });
    }, method: HttpUtils.POST);
  }

  _unCollect() {
    HttpUtils.getInstance()
        .request(ApiUrl.unCollect + "${widget.articleId}/json", (data) {
      setState(() {
        collect = false;
      });
    }, method: HttpUtils.POST);
  }
}
