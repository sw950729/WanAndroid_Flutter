import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/entity/HomeArticleListEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/widget/HomeListItemWidget.dart';
import 'package:silence_wan_android/widget/LoadMoreWidget.dart';
import 'package:silence_wan_android/widget/NoMoreWidget.dart';

/// @date:2020-02-12
/// @author:Silence
/// @describe:广场tab
class SquareListPage extends StatefulWidget {
  @override
  _SquareListPageState createState() => _SquareListPageState();
}

class _SquareListPageState extends State<SquareListPage>
    with AutomaticKeepAliveClientMixin {
  // 当前页数
  var currentPage = 0;

  // 一页多少条
  static const PAGE_SIZE = 20;

  // 列表数据集合
  List<HomeArticleListDatasEntity> listData = List();

  // 是否加载更多
  bool isLoadMore = true;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _getSquareList();
  }

  _SquareListPageState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels) {
        _getSquareList();
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
    super.build(context);
    if (DataUtils.listIsEmpty(listData)) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: new ListView.builder(
            itemBuilder: (context, i) => _createItem(i),
            itemCount: listData.length + 1,
            controller: _controller,
          ),
        ),
      );
    }
  }

  Future<Null> _onRefresh() async {
    currentPage = 0;
    _getSquareList();
  }

  @override
  bool get wantKeepAlive => true;

  void _getSquareList() {
    HttpUtils.getInstance().request(ApiUrl.squareList + "$currentPage/json",
        (data) {
      setState(() {
        var articleData = HomeArticleListEntity.fromJson(data);
        if (articleData.size < PAGE_SIZE) {
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
    });
  }

  Widget _createItem(int position) {
    if (position < listData.length) {
      return HomeListItemWidget(
        itemData: listData[position],
      );
    } else if (position == listData.length) {
      if (isLoadMore) {
        return LoadMoreWidget();
      } else {
        return NoMoreWidget();
      }
    }
    return null;
  }
}
