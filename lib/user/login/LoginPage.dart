import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silence_wan_android/common/ConfigInfo.dart';
import 'package:silence_wan_android/common/SpUtils.dart';
import 'package:silence_wan_android/common/Store.dart';
import 'package:silence_wan_android/common/Strings.dart';
import 'package:silence_wan_android/entity/LoginEntity.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';

import 'RegisterPage.dart';

/// @date:2020-01-13
/// @author:Silence
/// @describe:
class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userPassWordController = TextEditingController();
  bool _isShowPassWord = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Store.connect<ConfigModel>(builder: (context, child, model) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(Strings.login),
          centerTitle: true,
        ),
        key: scaffoldKey,
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(
                    labelText: Strings.userName,
                    hintText: Strings.userNameHint,
                    prefixIcon: Icon(Icons.person)),
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-z,A-Z,0-9]")),
                ],
              ),
              TextFormField(
                controller: _userPassWordController,
                decoration: InputDecoration(
                    labelText: Strings.password,
                    hintText: Strings.passwordHint,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isShowPassWord
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isShowPassWord = !_isShowPassWord;
                        });
                      },
                    )),
                obscureText: true,
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Container(
                  padding: EdgeInsets.only(top: 15.0),
                  width: double.infinity,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: _onLogin,
                    textColor: Colors.white,
                    child: Text(Strings.login),
                  ),
                  margin: EdgeInsets.all(5.0),
                ),
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(top: 15.0, right: 10.0),
                  child: Text(
                    Strings.goToRegister,
                    style: TextStyle(fontSize: 14.0, color: model.theme),
                  ),
                ),
                onTap: _launchRegister,
              )
            ],
          ),
        ),
      );
    });
  }

  void _onLogin() async {
    if (_userNameController.text.length == 0) {
      showToast(Strings.pleaseInputUserName);
      return;
    }
    if (_userPassWordController.text.length == 0) {
      showToast(Strings.passwordHint);
      return;
    }
    if (_userPassWordController.text.length < 6) {
      showToast(Strings.passwordAtLeast);
      return;
    }
    HttpUtils.getInstance().request(ApiUrl.login, (data) {
      LoginEntity entity = LoginEntity.fromJson(data);
      SpUtils.saveLoginInfo(entity.nickname);
      SpUtils.saveUserGuid(entity.id);
      _launchMain();
    }, method: HttpUtils.POST, requestData: {
      'username': _userNameController.text,
      'password': _userPassWordController.text,
    });
  }

  void _launchRegister() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  _launchMain() {
    Navigator.of(context).pop(SpUtils.getUserName());
  }

  void showToast(String msg) {
    final snackBar = new SnackBar(
      content: new Text(msg),
      backgroundColor: Colors.teal,
      duration: Duration(seconds: 2),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
