import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/AppColors.dart';
import 'package:silence_wan_android/common/NavigationUtils.dart';
import 'package:silence_wan_android/entity/NavigationEntity.dart';
import 'package:silence_wan_android/web/WebViewPage.dart';

/// @date:2020-02-12
/// @author:Silence
/// @describe:
class NavigationListItemWidget extends StatefulWidget {
  final NavigationEntity navigationEntity;

  NavigationListItemWidget({@required this.navigationEntity});

  @override
  _NavigationListItemWidgetState createState() =>
      _NavigationListItemWidgetState();
}

class _NavigationListItemWidgetState extends State<NavigationListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4.0,
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        //抗锯齿
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding:
              EdgeInsets.only(left: 5.0, top: 10.0, bottom: 10.0, right: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.navigationEntity.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 5,
                children: widget.navigationEntity.articles.map<Widget>((s) {
                  return GestureDetector(
                    child: Chip(
                      label: Text(
                        '${s.title}',
                        style: TextStyle(color:  AppColors.randomColor()),
                      ),
                      backgroundColor:AppColors.colorEFEFEF,
                    ),
                    onTap: () => NavigationUtils.pushPage(
                        context,
                        WebViewPage(
                          webTitle: s.title,
                          webUrl: s.link,
                          collect: s.collect,
                          isCanCollect: true,
                          articleId: s.id,
                        )),
                  );
                }).toList(),
              )
            ],
          ),
        ));
  }
}
