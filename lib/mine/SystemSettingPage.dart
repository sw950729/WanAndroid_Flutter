import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/AppColors.dart';
import 'package:silence_wan_android/common/ConfigInfo.dart';
import 'package:silence_wan_android/common/SpUtils.dart';
import 'package:silence_wan_android/common/Store.dart';
import 'package:silence_wan_android/common/Strings.dart';

/// @date:2020-01-24
/// @author:Silence
/// @describe: 系统设置
class SystemSettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SystemSettingPage();
}

class _SystemSettingPage extends State<SystemSettingPage> {
  bool setColor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.systemSetting),
          centerTitle: true,
        ),
        body: Container(
            margin:
                EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 5.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            Strings.systemColor,
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Text(Strings.setSystemColor),
                        ],
                      ),
                      IconButton(
                        icon: Icon(setColor
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                        onPressed: () {
                          setState(() {
                            setColor = !setColor;
                          });
                        },
                      )
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      setColor = !setColor;
                    });
                  },
                ),
                Visibility(
                  child: Flexible(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7, //每行2个
                        mainAxisSpacing: 10.0, //主轴方向间距
                        crossAxisSpacing: 10.0, //水平方向间距
                        childAspectRatio: 1.0, //纵轴缩放比例
                      ),
                      itemBuilder: (context, i) => _createItem(i),
                      itemCount: AppColors.themeList.length,
                    ),
                  ),
                  visible: setColor,
                )
              ],
            )));
  }

  Widget _createItem(int position) {
    return GestureDetector(
      child: CircleAvatar(
        radius: 15.0,
        backgroundColor: AppColors.themeList[position],
      ),
      onTap: () {
        Store.value<ConfigModel>(context)
            .$setTheme(AppColors.themeList[position]);
        SpUtils.saveTheme(position);
      },
    );
  }
}
