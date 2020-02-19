import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/AppColors.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/common/NavigationUtils.dart';
import 'package:silence_wan_android/entity/SystemTreeEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/project/ProjectTreeListPage.dart';

/// @date:2020-02-18
/// @author:Silence
/// @describe: 项目树
class ProjectTreePage extends StatefulWidget {
  @override
  _ProjectTreePageState createState() => _ProjectTreePageState();
}

class _ProjectTreePageState extends State<ProjectTreePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<SystemTreeEntity> projectTreeList = List();

  @override
  void initState() {
    super.initState();
    _getProjectsTree();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (DataUtils.listIsEmpty(projectTreeList)) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
          body: Container(
        padding: EdgeInsets.all(10.0),
        child: Wrap(
          spacing: 15,
          runSpacing: 4,
          children: projectTreeList.map<Widget>((s) {
            return GestureDetector(
              child: Chip(
                label: Text(
                  DataUtils.replaceAll(s.name),
                  style:
                      TextStyle(color: AppColors.randomColor(), fontSize: 15.0),
                ),
                backgroundColor: AppColors.colorEFEFEF,
              ),
              onTap: () {
                NavigationUtils.pushPage(
                    context,
                    ProjectTreeListPage(
                      id: s.id,
                      title: s.name,
                    ));
              },
            );
          }).toList(),
        ),
      ));
    }
  }

  _getProjectsTree() {
    HttpUtils.getInstance().request(ApiUrl.projectTree, (response) {
      setState(() {
        (response as List<dynamic>).forEach((v) {
          projectTreeList.add(SystemTreeEntity.fromJson(v));
        });
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
}
