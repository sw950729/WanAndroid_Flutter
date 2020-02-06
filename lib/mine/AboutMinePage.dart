import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/AppColors.dart';
import 'package:silence_wan_android/common/Strings.dart';

/// @date:2020-01-24
/// @author:Silence
/// @describe: 关于我
class AboutMinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.aboutMine),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Strings.author,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Text(
                        Strings.silence,
                        style: TextStyle(
                            fontSize: 14.0, color: AppColors.color999999),
                      ))
                ],
              )),
          Container(
              margin: EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Strings.weChat,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Text(
                        Strings.codeMa,
                        style: TextStyle(
                            fontSize: 14.0, color: AppColors.color999999),
                      ))
                ],
              )),
          Container(
              margin: EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Strings.weChatPublic,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Text(
                        Strings.codeMaWorkSpace,
                        style: TextStyle(
                            fontSize: 14.0, color: AppColors.color999999),
                      ))
                ],
              )),
          Container(
              margin: EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Strings.sourceProjectDesc,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Text(
                        Strings.sourceProjectUrl,
                        style: TextStyle(
                            fontSize: 14.0, color: AppColors.color999999),
                      ))
                ],
              )),
          Expanded(
              child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/wechat_public_account.jpg',
                  height: 200.0,
                  width: 200.0,
                  fit: BoxFit.cover,
                ),
                Text(
                  Strings.scanCode,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: AppColors.color999999,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
