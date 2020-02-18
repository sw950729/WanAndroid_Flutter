import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/AppColors.dart';
import 'package:silence_wan_android/common/DataUtils.dart';
import 'package:silence_wan_android/common/NavigationUtils.dart';
import 'package:silence_wan_android/common/Strings.dart';
import 'package:silence_wan_android/entity/SearchKeyEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';
import 'package:silence_wan_android/search/SearchListPage.dart';

/// @date:2020-02-18
/// @author:Silence
/// @describe:
class SearchKeyPage extends StatefulWidget {
  @override
  _SearchKeyPageState createState() => _SearchKeyPageState();
}

class _SearchKeyPageState extends State<SearchKeyPage> {
  List<SearchKeyEntity> searchKeyList = List();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSearchHotKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (string) {
            if (!DataUtils.isEmpty(string)) {
              _launchSearchList(string);
            }
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: Strings.inputKeyToSearch,
              hintStyle: TextStyle(color: AppColors.color999999)),
          maxLines: 1,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              if (!DataUtils.isEmpty(_searchController.text)) {
                _launchSearchList(_searchController.text);
              }
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              Strings.hotSearchKey,
              style: TextStyle(fontSize: 18.0, color: AppColors.colorPrimary),
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 10.0, top: 5.0),
              child: Wrap(
                runSpacing: 5,
                spacing: 10,
                children: searchKeyList.map<Widget>((s) {
                  return GestureDetector(
                    child: Chip(
                      label: Text(
                        '${s.name}',
                        style: TextStyle(color: AppColors.randomColor()),
                      ),
                      backgroundColor: AppColors.colorEFEFEF,
                    ),
                    onTap: () {
                      _launchSearchList(s.name);
                    },
                  );
                }).toList(),
              ))
        ],
      ),
    );
  }

  _launchSearchList(String key) {
    NavigationUtils.pushPage(context, SearchListPage(keyWord: key));
  }

  _getSearchHotKey() {
    HttpUtils.getInstance().request(ApiUrl.searchHotKey, (response) {
      setState(() {
        (response as List<dynamic>).forEach((v) {
          searchKeyList.add(SearchKeyEntity.fromJson(v));
        });
      });
    });
  }
}
