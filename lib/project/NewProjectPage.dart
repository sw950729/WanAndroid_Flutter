import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/entity/ProjectListEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/widget/LoadMoreWidget.dart';
import 'package:silence_wan_android/widget/NoMoreWidget.dart';
import 'package:silence_wan_android/widget/ProjectListItemWidget.dart';

/// @date:2020-02-19
/// @author:Silence
/// @describe:
class NewProjectPage extends StatefulWidget {
  @override
  _NewProjectPageState createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  List<ProjectListItem> newProjectList = List();
  var isLoadingMore = true;
  ScrollController _controller = ScrollController();
  var currentPage = 0;
  static const PAGE_SIZE = 15;

  @override
  void initState() {
    super.initState();
    _getNewProject();
  }

  _NewProjectPageState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels) {
        _getNewProject();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (DataUtils.listIsEmpty(newProjectList)) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemBuilder: (context, position) => _createItem(position),
            itemCount: newProjectList.length + 1,
            controller: _controller,
            shrinkWrap: true,
          ),
        ),
      );
    }
  }

  Future<Null> _onRefresh() async {
    currentPage = 0;
    newProjectList.clear();
    _getNewProject();
  }

  _getNewProject() {
    HttpUtils.getInstance().request(ApiUrl.newProjectList + "$currentPage/json",
        (data) {
      setState(() {
        ProjectListEntity projectListEntity = ProjectListEntity.fromJson(data);
        if (!DataUtils.listIsEmpty(projectListEntity.datas)) {
          newProjectList.addAll(projectListEntity.datas);
          currentPage++;
        }
        if (projectListEntity.datas.length < PAGE_SIZE) {
          isLoadingMore = false;
        }
      });
    });
  }

  Widget _createItem(position) {
    if (position == newProjectList.length && !isLoadingMore) {
      return NoMoreWidget();
    } else if (position == newProjectList.length && isLoadingMore) {
      return LoadMoreWidget();
    } else {
      return ProjectListItemWidget(
        projectListItem: newProjectList[position],
      );
    }
  }
}
