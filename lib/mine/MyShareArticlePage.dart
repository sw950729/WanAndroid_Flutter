import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/common/StateWithLifecycle.dart';
import 'package:silence_wan_android/common/Strings.dart';
import 'package:silence_wan_android/entity/ShareArticleListEntity.dart';
import 'package:silence_wan_android/mine/AddShareArticlePage.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/widget/EmptyWidget.dart';
import 'package:silence_wan_android/widget/LoadMoreWidget.dart';
import 'package:silence_wan_android/widget/NoMoreWidget.dart';
import 'package:silence_wan_android/widget/ShareArticleItemWidget.dart';

/// @date:2020-01-24
/// @author:Silence
/// @describe: 我的分享文章
class MyShareArticlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.myShareArticle),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AddShareArticlePage()));
            },
          )
        ],
      ),
      body: ShareArticleListPage(),
    );
  }
}

class ShareArticleListPage extends StatefulWidget {
  @override
  _ShareArticleListPage createState() => _ShareArticleListPage();
}

class _ShareArticleListPage extends StateWithLifecycle<ShareArticleListPage> {
  var shareArticleList = List<ShareArticleList>();
  var currentPage = 1;
  static const PAGE_SIZE = 20;

  //是否加载过数据，如果加载过数据，没有数据源展示emptyWidget。否则就是loading
  var isLoading = false;
  var isLoadingMore = true;
  ScrollController _controller = ScrollController();

  @override
  void onResume() {
    super.onResume();
    _getShareArticleList();
  }

  _ShareArticleListPage() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels) {
        _getShareArticleList();
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
    if (DataUtils.listIsEmpty(shareArticleList) && !isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (DataUtils.listIsEmpty(shareArticleList) && isLoading) {
      return EmptyWidget();
    } else {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemBuilder: (context, position) => _createItem(position),
            itemCount: shareArticleList.length + 1,
            controller: _controller,
            shrinkWrap: true,
          ),
        ),
      );
    }
  }

  Future<Null> _onRefresh() async {
    currentPage = 1;
    shareArticleList.clear();
    _getShareArticleList();
  }

  _getShareArticleList() {
    HttpUtils.getInstance().request(ApiUrl.myShareArticle + "$currentPage/json",
        (responseData) {
      setState(() {
        isLoading = true;
        ShareArticleListEntity shareArticleListEntity =
            ShareArticleListEntity.fromJson(responseData);
        if (!DataUtils.listIsEmpty(
            shareArticleListEntity.shareArticles.datas)) {
          shareArticleList.addAll(shareArticleListEntity.shareArticles.datas);
          currentPage++;
        }
        if (shareArticleListEntity.shareArticles.datas.length < PAGE_SIZE) {
          isLoadingMore = false;
        }
      });
    });
  }

  void deleteArticle(position) {
    setState(() {
      shareArticleList.removeAt(position);
    });
  }

  Widget _createItem(position) {
    if (position == shareArticleList.length && !isLoadingMore) {
      return NoMoreWidget();
    } else if (position == shareArticleList.length && isLoadingMore) {
      return LoadMoreWidget();
    } else {
      return ShareArticleItemWidget(
        shareArticleList: shareArticleList[position],
        position: position,
        deleteArticle: deleteArticle,
      );
    }
  }
}
