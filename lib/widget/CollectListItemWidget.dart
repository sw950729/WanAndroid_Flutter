import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/AppColors.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/common/Strings.dart';
import 'package:silence_wan_android/entity/CollectListEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';

/// @date:2020-01-26
/// @author:Silence
/// @describe:

class CollectListItemWidget extends StatefulWidget {
  final CollectListDatas collectList;
  final int position;
  final ValueChanged<int> onChanged;

  CollectListItemWidget(
      {@required this.collectList, this.position, this.onChanged}) {
    collectList.title = DataUtils.replaceAll(collectList.title);
  }

  @override
  State<StatefulWidget> createState() => _CollectListItemWidget();
}

class _CollectListItemWidget extends State<CollectListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4.0,
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    DataUtils.isEmpty(widget.collectList.author)
                        ? Strings.anonymousUser
                        : widget.collectList.author,
                    style:
                        TextStyle(color: AppColors.color999999, fontSize: 14.0),
                  ),
                  Text(
                    widget.collectList.niceDate,
                    style:
                        TextStyle(color: AppColors.color999999, fontSize: 14.0),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  widget.collectList.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.collectList.chapterName,
                    style:
                        TextStyle(color: AppColors.color999999, fontSize: 14.0),
                  ),
                  IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        _unCollect();
                      })
                ],
              ),
            ],
          ),
        ));
  }

  _unCollect() {
    HttpUtils.getInstance().request(
        ApiUrl.unCollectList + "${widget.collectList.id}/json", (response) {
      setState(() {
        widget.onChanged(widget.position);
      });
    }, requestData: {
      'originId': widget.collectList.originId == null
          ? -1
          : widget.collectList.originId,
    }, method: HttpUtils.POST);
  }
}
