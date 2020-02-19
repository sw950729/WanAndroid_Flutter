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
class ProjectTreeListPage extends StatelessWidget {
  final id;
  final title;

  ProjectTreeListPage({@required this.id, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: TreeListPage(id: id),
    );
  }
}

class TreeListPage extends StatefulWidget {
  final id;

  TreeListPage({@required this.id});

  @override
  _TreeListPageState createState() => _TreeListPageState();
}

class _TreeListPageState extends State<TreeListPage> {
  List<ProjectListItem> projectList = List();
  var isLoadingMore = true;
  ScrollController _controller = ScrollController();
  var currentPage = 0;
  static const PAGE_SIZE = 15;

  _TreeListPageState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels) {
        _getProjectList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getProjectList();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (DataUtils.listIsEmpty(projectList)) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemBuilder: (context, position) => _createItem(position),
            itemCount: projectList.length + 1,
            controller: _controller,
            shrinkWrap: true,
          ),
        ),
      );
    }
  }

  Future<Null> _onRefresh() async {
    currentPage = 0;
    projectList.clear();
    _getProjectList();
  }

  _getProjectList() {
    HttpUtils.getInstance().request(ApiUrl.projectList+"$currentPage/json", (response) {
      setState(() {
        ProjectListEntity projectListEntity =
            ProjectListEntity.fromJson(response);
        if (!DataUtils.listIsEmpty(projectListEntity.datas)) {
          projectList.addAll(projectListEntity.datas);
          currentPage++;
        }
        if (projectListEntity.datas.length < PAGE_SIZE) {
          isLoadingMore = false;
        }
      });
    }, requestData: {"cid": widget.id});
  }

  Widget _createItem(position) {
    if (position == projectList.length && !isLoadingMore) {
      return NoMoreWidget();
    } else if (position == projectList.length && isLoadingMore) {
      return LoadMoreWidget();
    } else {
      return ProjectListItemWidget(
        projectListItem: projectList[position],
      );
    }
  }
}
