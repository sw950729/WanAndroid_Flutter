import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:silence_flutter_study/common/DataUtils.dart';
import 'package:silence_flutter_study/entity/BannerEntity.dart';
import 'package:silence_flutter_study/entity/HomeArticleListEntity.dart';
import 'package:silence_flutter_study/net/ApiUrl.dart';
import 'package:silence_flutter_study/net/HttpUtils.dart';
import 'package:silence_flutter_study/web/WebViewPage.dart';
import 'package:silence_flutter_study/widget/ListItemWidget.dart';
import 'package:silence_flutter_study/widget/LoadMoreWidget.dart';
import 'package:silence_flutter_study/widget/NoMoreWidget.dart';

import '../../common/Strings.dart';

/// @date:2020-01-14
/// @author:Silence
/// @describe:
class HomeViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeViewPage();
}

class _HomeViewPage extends State<HomeViewPage> {
  // 当前页数
  var currentPage = 0;

  // 一页多少条
  static const PAGE_SIZE = 20;

  // 列表数据集合
  List<HomeArticleListDatasEntity> listData = List();

  // banner 数据集合
  List<BannerEntity> bannerList = List();

  // 是否加载更多
  bool isLoadMore = true;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _getBanner();
    _getHomeArticleList();
  }

  _HomeViewPage() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels) {
        _getHomeArticleList();
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
    if (DataUtils.listIsEmpty(bannerList)) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
            title: Text(
              Strings.homePageTitle,
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: null,
              )
            ]),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: new ListView.builder(
            itemBuilder: (context, i) => _createItem(i),
            itemCount: listData.length + 2,
            controller: _controller,
          ),
        ),
      );
    }
  }

  void _getBanner() {
    HttpUtils.getInstance().request(ApiUrl.banner, (data) {
      setState(() {
        bannerList.clear();
        (data as List<dynamic>).forEach((v) {
          bannerList.add(BannerEntity.fromJson(v));
        });
      });
    });
  }

  void _getHomeArticleList() {
    HttpUtils.getInstance()
        .request(ApiUrl.homeArticleList + "$currentPage/json", (data) {
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
    });
  }

  Future<Null> _onRefresh() async {
    currentPage = 0;
    _getBanner();
    _getHomeArticleList();
  }

  Widget _createItem(int position) {
    if (position == 0) {
      return Container(
        width: double.infinity,
        height: 200.0,
        child: Swiper(
          itemCount: bannerList.length,
          itemBuilder: (BuildContext context, int index) {
            return Image.network(bannerList[index].imagePath);
          },
          autoplay: true,
          pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(size: 6.5, activeSize: 6.5)),
          onTap: (index) => _onBannerItemClick(bannerList[index]),
        ),
      );
    } else if (!DataUtils.listIsEmpty(listData)) {
      if (position <= listData.length) {
        return ListItemWidget(
          itemData: listData[position - 1],
        );
      } else if (position == listData.length + 1) {
        if (isLoadMore) {
          return LoadMoreWidget();
        } else {
          return NoMoreWidget();
        }
      }
    }
    return null;
  }

  void _onBannerItemClick(BannerEntity bannerListItem) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WebViewPage(
              webTitle: bannerListItem.title,
              webUrl: bannerListItem.url,
              isBanner: true,
            )));
  }
}
