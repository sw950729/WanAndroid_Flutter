import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/common/NavigationUtils.dart';
import 'package:silence_wan_android/entity/ProjectListEntity.dart';
import 'package:silence_wan_android/web/WebViewPage.dart';

/// @date:2020-02-19
/// @author:Silence
/// @describe:
class ProjectListItemWidget extends StatefulWidget {
  final ProjectListItem projectListItem;

  ProjectListItemWidget({@required this.projectListItem}) {
    projectListItem.title = DataUtils.replaceAll(projectListItem.title);
  }

  @override
  _ProjectListItemWidgetState createState() => _ProjectListItemWidgetState();
}

class _ProjectListItemWidgetState extends State<ProjectListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CachedNetworkImage(
                    width: 90.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                    imageUrl: widget.projectListItem.envelopePic,
                    placeholder: (context, url) => Container(
                      width: 90.0,
                      height: 120.0,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.projectListItem.title,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8.0),
                          child: Text(
                            DataUtils.replaceAll(widget.projectListItem.desc),
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
              Container(
                alignment: Alignment.topRight,
                child: Text(widget.projectListItem.niceDate),
              ),
            ],
          ),
        ),
        onTap: () {
          NavigationUtils.pushPage(
              context,
              WebViewPage(
                webUrl: widget.projectListItem.link,
                webTitle: widget.projectListItem.title,
                collect: widget.projectListItem.collect,
                articleId: widget.projectListItem.id,
              ));
        },
      ),
    );
  }
}
