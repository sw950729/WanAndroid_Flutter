import 'package:provide/provide.dart';
import 'package:silence_wan_android/common/ConfigInfo.dart';

class Store {
  //  我们将会在main.dart中runAPP实例化init
  static init({model, child, dispose = true}) {
    final providers = Providers()..provide(Provider.value(ConfigModel()));
    return ProviderNode(child: child, providers: providers, dispose: dispose);
  }

  //  通过Provide小部件获取状态封装
  static connect<T>({builder, child, scope}) {
    return Provide<T>(builder: builder, child: child, scope: scope);
  }

  //  通过Provide.value<T>(context)获取封装
  static T value<T>(context, {scope}) {
    return Provide.value<T>(context, scope: scope);
  }
}
