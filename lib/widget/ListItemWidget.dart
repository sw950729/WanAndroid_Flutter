import 'package:flutter/material.dart';
import 'package:silence_flutter_study/common/DataUtils.dart';
import 'package:silence_flutter_study/common/Strings.dart';
import 'package:silence_flutter_study/entity/HomeArticleListEntity.dart';
import 'package:silence_flutter_study/web/WebViewPage.dart';

/// @date:2020-01-20
/// @author:Silence
/// @describe:
class ListItemWidget extends StatefulWidget {
  final HomeArticleListDatasEntity itemData;

  ListItemWidget({@required this.itemData}) {
    this.itemData.title = DataUtils.replaceAll(this.itemData.title);
  }

  @override
  State<ListItemWidget> createState() => _ListItemWidget();
}

class _ListItemWidget extends State<ListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                  child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  widget.itemData.title,
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
                onPressed: () {},
              ),
            ]),
            Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(bottom: 5.0, right: 5.0),
                  child: Text(
                    widget.itemData.niceDate,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(left: 10.0, bottom: 5.0),
                  child: Text(
                    DataUtils.isEmpty(widget.itemData.author)
                        ? Strings.shareUser + "${widget.itemData.shareUser}"
                        : Strings.author + "${widget.itemData.author}",
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
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
              webTitle: widget.itemData.title,
              webUrl: widget.itemData.link,
              collect: widget.itemData.collect,
              isBanner: false,
            )));
  }
}
