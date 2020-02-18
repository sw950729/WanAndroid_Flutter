import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/entity/HomeArticleListEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/widget/EmptyWidget.dart';
import 'package:silence_wan_android/widget/HomeListItemWidget.dart';
import 'package:silence_wan_android/widget/LoadMoreWidget.dart';
import 'package:silence_wan_android/widget/NoMoreWidget.dart';

/// @date:2020-02-16
/// @author:Silence
/// @describe:
class ArticleListPage extends StatefulWidget {
  final int id;

  ArticleListPage({@required this.id});

  @override
  _ArticleListPageState createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  // 当前页数
  var currentPage = 0;

  // 一页多少条
  static const PAGE_SIZE = 20;

  // 列表数据集合
  List<HomeArticleListDatasEntity> listData = List();

  // 是否加载更多
  bool isLoadMore = true;
  var isLoading = false;
  ScrollController _controller = ScrollController();

  _ArticleListPageState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels) {
        _getArticleList();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getArticleList();
  }

  @override
  Widget build(BuildContext context) {
    if (DataUtils.listIsEmpty(listData) && !isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (DataUtils.listIsEmpty(listData) && isLoading) {
      return EmptyWidget();
    } else {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: new ListView.builder(
          itemBuilder: (context, i) => _createItem(i),
          itemCount: listData.length + 1,
          controller: _controller,
          addAutomaticKeepAlives: false,
          shrinkWrap: true,
        ),
      );
    }
  }

  Future<Null> _onRefresh() async {
    currentPage = 0;
    _getArticleList();
  }

  void _getArticleList() {
    HttpUtils.getInstance().request(
      ApiUrl.systemTreeList + "$currentPage/json",
      (data) {
        setState(() {
          var articleData = HomeArticleListEntity.fromJson(data);
          if (articleData.datas.length < PAGE_SIZE) {
            isLoadMore = false;
          }
          if (currentPage == 0) {
            listData.clear();
            listData.addAll(articleData.datas);
          } else {
            listData.addAll(articleData.datas);
          }
          currentPage++;
        });
      },
      requestData: {"cid": widget.id},
    );
  }

  Widget _createItem(position) {
    if (position == listData.length && !isLoadMore) {
      return NoMoreWidget();
    } else if (position == listData.length && isLoadMore) {
      return LoadMoreWidget();
    } else {
      return HomeListItemWidget(
        itemData: listData[position],
      );
    }
  }

}
