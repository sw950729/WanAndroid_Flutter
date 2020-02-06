import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/AppColors.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/common/Strings.dart';
import 'package:silence_wan_android/common/UrlUtils.dart';
import 'package:silence_wan_android/entity/RecordHistoryEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/web/WebViewPage.dart';
import 'package:silence_wan_android/widget/EmptyWidget.dart';
import 'package:silence_wan_android/widget/LoadMoreWidget.dart';
import 'package:silence_wan_android/widget/NoMoreWidget.dart';

/// @date:2020-01-24
/// @author:Silence
/// @describe: 积分记录
class IntegralRecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.coinCountHistory),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
              onTap: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => WebViewPage(
                              webUrl: UrlUtils.integralHelp,
                              webTitle: Strings.coinCountHelp,
                              isCanCollect: false,
                            )))
                  },
              child: Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.help_outline)))
        ],
      ),
      body: IntegralRecordListPage(),
    );
  }
}

class IntegralRecordListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IntegralRecordListPage();
}

class _IntegralRecordListPage extends State<IntegralRecordListPage> {
  var recordHistoryList = List<RecordHistoryList>();
  var currentPage = 1;
  static const PAGE_SIZE = 20;

  //是否加载过数据，如果加载过数据，没有数据源展示emptyWidget。否则就是loading
  var isLoading = false;
  var isLoadingMore = true;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    getIntegralRecord();
  }

  _IntegralRecordListPage() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels) {
        getIntegralRecord();
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
    if (DataUtils.listIsEmpty(recordHistoryList) && !isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (DataUtils.listIsEmpty(recordHistoryList) && isLoading) {
      return EmptyWidget();
    } else {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemBuilder: (context, position) {
              return _createItem(position);
            },
            itemCount: recordHistoryList.length + 1,
            controller: _controller,
            physics: AlwaysScrollableScrollPhysics(),
          ),
        ),
      );
    }
  }

  void getIntegralRecord() async {
    HttpUtils.getInstance().request(ApiUrl.recordHistory + "$currentPage/json",
        (data) {
      setState(() {
        isLoading = true;
        RecordHistoryEntity recordHistoryEntity =
            RecordHistoryEntity.fromJson(data);
        if (!DataUtils.listIsEmpty(recordHistoryEntity.datas)) {
          recordHistoryList.addAll(recordHistoryEntity.datas);
          currentPage++;
        }
        if (recordHistoryEntity.datas.length < PAGE_SIZE) {
          isLoadingMore = false;
        }
      });
    });
  }

  Future<Null> _onRefresh() async {
    currentPage = 1;
    recordHistoryList.clear();
    getIntegralRecord();
  }

  Widget _createItem(position) {
    if (position == recordHistoryList.length && !isLoadingMore) {
      return NoMoreWidget();
    } else if (position == recordHistoryList.length && isLoadingMore) {
      return LoadMoreWidget();
    } else {
      String desc = recordHistoryList[position].desc;
      String descStr;
      if (desc.contains(Strings.coinCount)) {
        descStr = desc.substring(desc.indexOf(Strings.coinCount), desc.length);
      } else {
        descStr = "";
      }
      return Card(
        elevation: 4.0,
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(recordHistoryList[position].reason + descStr),
                  Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(
                        DataUtils.getFormatData(
                            recordHistoryList[position].date,
                            Strings.yyyyMMDDHHMMSS),
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10.0),
              child: Text(
                "+" + recordHistoryList[position].coinCount.toString(),
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorPrimary),
              ),
            )
          ],
        ),
      );
    }
  }
}
