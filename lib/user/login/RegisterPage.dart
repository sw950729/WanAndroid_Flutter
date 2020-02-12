import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silence_wan_android/common/Strings.dart';
import 'package:silence_wan_android/net/ApiUrl.dart';
import 'package:silence_wan_android/net/HttpUtils.dart';

/// @date:2020-01-22
/// @author:Silence
/// @describe:
class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userPassWordController = TextEditingController();
  TextEditingController _makeSureUserPassWordController =
      TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(Strings.register),
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
                  prefixIcon: Icon(Icons.lock)),
              obscureText: true,
            ),
            TextFormField(
              controller: _makeSureUserPassWordController,
              decoration: InputDecoration(
                  labelText: Strings.makeSurePassword,
                  hintText: Strings.passwordHint,
                  prefixIcon: Icon(Icons.lock)),
              obscureText: true,
            ),
            Container(
              padding: EdgeInsets.only(top: 15.0),
              width: double.infinity,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: _onRegister,
                textColor: Colors.white,
                child: Text(Strings.register),
              ),
              margin: EdgeInsets.all(5.0),
            ),
          ],
        ),
      ),
    );
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
    if (_makeSureUserPassWordController.text.length == 0) {
      showToast(Strings.passwordHint);
      return;
    }
    if (_userPassWordController.text.length < 6) {
      showToast(Strings.passwordAtLeast);
      return;
    }
    if (_makeSureUserPassWordController.text.length < 6) {
      showToast(Strings.passwordAtLeast);
      return;
    }
    HttpUtils.getInstance().request(ApiUrl.register, (data) {
      showToast(Strings.registerSuccess);
      Navigator.of(context).pop();
    }, method: HttpUtils.POST, requestData: {
      'username': _userNameController.text,
      'password': _userPassWordController.text,
      'repassword': _makeSureUserPassWordController.text
    });
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
