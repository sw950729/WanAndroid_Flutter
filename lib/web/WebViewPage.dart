import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';

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
  FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();
  double lineProgress = 0.0;

  _WebViewPage({this.collect});

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onProgressChanged.listen((progress) {
      print(progress);
      setState(() {
        lineProgress = progress;
      });
    });
    flutterWebViewPlugin.onDestroy.listen((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebViewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
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
          bottom: PreferredSize(
            child: _progressBar(lineProgress, context),
            preferredSize: Size.fromHeight(1.0),
          )),
      url: widget.webUrl,
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    );
  }

  _progressBar(double progress, BuildContext context) {
    return Container(
      child: LinearProgressIndicator(
        backgroundColor: Colors.white70.withOpacity(0),
        value: progress == 1.0 ? 0 : progress,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.tealAccent),
      ),
      height: 2.0,
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
