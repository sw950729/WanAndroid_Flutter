/// @date:2020-01-15
/// @author:Silence
/// @describe:
class ApiUrl {
  static var baseUrl = "https://www.wanandroid.com";

  //登录、注册、退出
  static var register = "/user/register";
  static var login = "/user/login";
  static var logout = "/user/logout/json";

  //首页banner
  static var banner = "/banner/json";

  //首页文章列表
  static var homeArticleList = "/article/list/";

  //获取个人积分
  static var userInfo = "/lg/coin/userinfo/json";
}
