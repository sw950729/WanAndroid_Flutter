import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../common/DataUtils.dart';

/// @date:2020-01-20
/// @author:Silence
/// @describe:
class WebViewPage extends StatefulWidget {
  final String webUrl;
  final String webTitle;
  final bool collect;
  final bool isBanner;

  WebViewPage({
    @required this.webTitle,
    @required this.webUrl,
    this.collect = false,
    this.isBanner = false,
  });

  State<WebViewPage> createState() => _WebViewPage();
}

class _WebViewPage extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DataUtils.replaceAll(widget.webTitle)),
        centerTitle: true,
        actions: <Widget>[
          Visibility(
            visible: !widget.isBanner,
            child: IconButton(
              icon: Icon(
                widget.collect ? Icons.favorite : Icons.favorite_border,
                color: widget.collect ? Colors.red : null,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: WebView(
          initialUrl: widget.webUrl,
          javascriptMode: JavascriptMode.unrestricted),
    );
  }
}
