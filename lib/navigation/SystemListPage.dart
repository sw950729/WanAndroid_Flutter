import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/entity/SystemTreeEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/widget/SystemTreeItemWidget.dart';

/// @date:2020-02-12
/// @author:Silence
/// @describe: 体系tab
class SystemListPage extends StatefulWidget {
  @override
  _SystemListPageState createState() => _SystemListPageState();
}

class _SystemListPageState extends State<SystemListPage>
    with AutomaticKeepAliveClientMixin {
  List<SystemTreeEntity> systemTreeList = List();

  @override
  void initState() {
    super.initState();
    _getSystemTree();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (DataUtils.listIsEmpty(systemTreeList)) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, i) => _createItem(i),
        itemCount: systemTreeList.length,
        addAutomaticKeepAlives: false,
        shrinkWrap: true,
      );
    }
  }

  _getSystemTree() {
    HttpUtils.getInstance().request(ApiUrl.systemTree, (response) {
      (response as List<dynamic>).forEach((v) {
        setState(() {
          systemTreeList.add(SystemTreeEntity.fromJson(v));
        });
      });
    });
  }

  Widget _createItem(int position) {
    return SystemListItemWidget(
      systemTreeEntity: systemTreeList[position],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
