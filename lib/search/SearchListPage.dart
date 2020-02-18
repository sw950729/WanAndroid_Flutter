import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/entity/HomeArticleListEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/widget/HomeListItemWidget.dart';
import 'package:silence_wan_android/widget/LoadMoreWidget.dart';
import 'package:silence_wan_android/widget/NoMoreWidget.dart';

/// @date:2020-02-18
/// @author:Silence
/// @describe:
class SearchListPage extends StatelessWidget {
  final keyWord;

  SearchListPage({@required this.keyWord});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(keyWord),
        centerTitle: true,
      ),
      body: SearchContentListPage(
        keyWord: keyWord,
      ),
    );
  }
}

class SearchContentListPage extends StatefulWidget {
  final keyWord;

  SearchContentListPage({this.keyWord});

  @override
  State<SearchContentListPage> createState() => _SearchContentListPage();
}

class _SearchContentListPage extends State<SearchContentListPage> {
  var currentPage = 0;
  List<HomeArticleListDatasEntity> searchList = List();
  bool isLoadMore = true;
  var isLoading = false;
  ScrollController _controller = ScrollController();

  _SearchContentListPage() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels) {
        _getSearchList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getSearchList();
  }

  @override
  Widget build(BuildContext context) {
    if (DataUtils.listIsEmpty(searchList)) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemBuilder: (context, position) => _createItem(position),
          itemCount: searchList.length + 1,
          controller: _controller,
          shrinkWrap: true,
        ),
      );
    }
  }

  Future<Null> _onRefresh() async {
    currentPage = 0;
    _getSearchList();
  }

  _getSearchList() {
    HttpUtils.getInstance()
        .request(ApiUrl.searchList + "$currentPage" + "/json", (responseData) {
      setState(() {
        var articleData = HomeArticleListEntity.fromJson(responseData);
        if (articleData.curPage < articleData.pageCount) {
          isLoadMore = true;
        } else {
          isLoadMore = false;
        }
        if (currentPage == 0) {
          searchList.clear();
          searchList.addAll(articleData.datas);
        } else {
          searchList.addAll(articleData.datas);
        }
        currentPage++;
      });
    }, method: HttpUtils.POST, requestData: {"k": widget.keyWord});
  }

  Widget _createItem(position) {
    if (position == searchList.length && !isLoadMore) {
      return NoMoreWidget();
    } else if (position == searchList.length && isLoadMore) {
      return LoadMoreWidget();
    } else {
      return HomeListItemWidget(
        itemData: searchList[position],
        keyWord: widget.keyWord,
      );
    }
  }
}
