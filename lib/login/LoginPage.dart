import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silence_flutter_study/common/ImagesUrls.dart';
import 'package:silence_flutter_study/common/SpUtils.dart';
import 'package:silence_flutter_study/common/Strings.dart';
import 'package:silence_flutter_study/entity/LoginEntity.dart';
import 'package:silence_flutter_study/main/MainPage.dart';
import 'package:silence_flutter_study/net/ApiUrl.dart';
import 'package:silence_flutter_study/net/HttpUtils.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userPassWordController = TextEditingController();
  bool _isShowPassWord = false;
  GlobalKey _formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(ImagesUrls.loginBackgroundUrl),
                fit: BoxFit.cover)),
        child: Form(
          key: _formKey,
          autovalidate: true,
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
                padding: EdgeInsets.only(top: 25.0),
                child: ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: _onLogin,
                              textColor: Colors.white,
                              child: Text(Strings.login),
                            ),
                            margin: EdgeInsets.all(5.0),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: _onRegister,
                              textColor: Colors.white,
                              child: Text(Strings.register),
                            ),
                            margin: EdgeInsets.all(5.0),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
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
      _launchMain();
    }, method: HttpUtils.POST, data: {
      'username': _userNameController.text,
      'password': _userPassWordController.text,
    });
  }

  void _onRegister() {
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
    HttpUtils.getInstance()
        .request(ApiUrl.register, (data) {}, method: HttpUtils.POST, data: {
      'username': _userNameController.text,
      'password': _userPassWordController.text,
      'repassword': _userPassWordController.text
    });
  }

  _launchMain() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> rout) => false);
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
