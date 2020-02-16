import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/AppColors.dart';
import 'package:silence_wan_android/common/NavigationUtils.dart';
import 'package:silence_wan_android/entity/SystemTreeEntity.dart';
import 'package:silence_wan_android/navigation/SystemTreeListPage.dart';

/// @date:2020-02-12
/// @author:Silence
/// @describe:
class SystemListItemWidget extends StatefulWidget {
  final SystemTreeEntity systemTreeEntity;

  SystemListItemWidget({@required this.systemTreeEntity});

  @override
  _SystemListItemWidget createState() => _SystemListItemWidget();
}

class _SystemListItemWidget extends State<SystemListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4.0,
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        //抗锯齿
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          child: Container(
            padding:
                EdgeInsets.only(left: 5.0, top: 10.0, bottom: 10.0, right: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.systemTreeEntity.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: widget.systemTreeEntity.children.map<Widget>((s) {
                    return Chip(
                      label: Text(
                        '${s.name}',
                        style: TextStyle(color: AppColors.randomColor()),
                      ),
                      backgroundColor: AppColors.colorEFEFEF,
                    );
                  }).toList(),
                )
              ],
            ),
          ),
          onTap: () => NavigationUtils.pushPage(
              context,
              SystemTreeListPage(
                title: widget.systemTreeEntity.name,
                children: widget.systemTreeEntity.children,
              )),
        ));
  }
}
