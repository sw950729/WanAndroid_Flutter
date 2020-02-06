import 'package:flutter/material.dart';

abstract class StateWithLifecycle<T extends StatefulWidget> extends State {
  String tagInStateWithLifecycle = 'StateWithLifecycle';

  // 参照State中写法，防止子类获取不到正确的widget。
  T get widget => super.widget;

  @override
  void initState() {
    super.initState();
    onCreate();
    onResume();
  }

  @override
  void deactivate() {
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      onResume();
    } else {
      onPause();
    }
  }

  @override
  void dispose() {
    onDestroy();
    super.dispose();
  }

  /// 用于让子类去实现的初始化方法
  void onCreate() {
    debugPrint('$tagInStateWithLifecycle --> onCreate()');
  }

  /// 用于让子类去实现的不可见变为可见时的方法
  void onResume() {
    debugPrint('$tagInStateWithLifecycle --> onResume()');
  }

  /// 用于让子类去实现的可见变为不可见时调用的方法。
  void onPause() {
    debugPrint('$tagInStateWithLifecycle --> onPause()');
  }

  /// 用于让子类去实现的销毁方法。
  void onDestroy() {
    debugPrint('$tagInStateWithLifecycle --> onDestroy()');
  }
}
