import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/common/Strings.dart';
import 'package:silence_wan_android/entity/CollectListEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/widget/CollectListItemWidget.dart';
import 'package:silence_wan_android/widget/EmptyWidget.dart';
import 'package:silence_wan_android/widget/LoadMoreWidget.dart';
import 'package:silence_wan_android/widget/NoMoreWidget.dart';

/// @date:2020-01-24
/// @author:Silence
/// @describe: 我的收藏
class MyCollectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.myCollect),
          centerTitle: true,
        ),
        body: CollectListPage());
  }
}

class CollectListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CollectListPage();
}

class _CollectListPage extends State<CollectListPage> {
  var collectList = List<CollectListDatas>();
  var currentPage = 0;
  static const PAGE_SIZE = 20;

  //是否加载过数据，如果加载过数据，没有数据源展示emptyWidget。否则就是loading
  var isLoading = false;
  var isLoadingMore = true;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _getCollectList();
  }

  _CollectListPage() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels) {
        _getCollectList();
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
    if (DataUtils.listIsEmpty(collectList) && !isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (DataUtils.listIsEmpty(collectList) && isLoading) {
      return EmptyWidget();
    } else {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemBuilder: (context, position) => _createItem(position),
            itemCount: collectList.length + 1,
            controller: _controller,
            physics: AlwaysScrollableScrollPhysics(),
          ),
        ),
      );
    }
  }

  Future<Null> _onRefresh() async {
    currentPage = 0;
    collectList.clear();
    _getCollectList();
  }

  _getCollectList() {
    HttpUtils.getInstance().request(ApiUrl.collectList + "$currentPage/json",
        (data) {
      setState(() {
        isLoading = true;
        CollectListEntity entity = CollectListEntity.fromJson(data);
        if (!DataUtils.listIsEmpty(entity.datas)) {
          collectList.addAll(entity.datas);
          currentPage++;
        }
        if (entity.datas.length < PAGE_SIZE) {
          isLoadingMore = false;
        }
      });
    });
  }

  void unCollectArticle(position) {
    setState(() {
      collectList.removeAt(position);
    });
  }

  Widget _createItem(position) {
    if (position == collectList.length && !isLoadingMore) {
      return NoMoreWidget();
    } else if (position == collectList.length && isLoadingMore) {
      return LoadMoreWidget();
    } else {
      return CollectListItemWidget(
        collectList: collectList[position],
        position: position,
        onChanged: unCollectArticle,
      );
    }
  }
}
