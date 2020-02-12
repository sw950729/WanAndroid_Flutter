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
  static var recordHistory = "/lg/coin/list/";

  //收藏
  static var collect = "/lg/collect/";
  static var unCollect = "/lg/uncollect_originId/";
  static var collectList = "/lg/collect/list/";
  static var unCollectList = "/lg/uncollect/";

  //分享
  static var myShareArticle = "/user/lg/private_articles/";
  static var deleteArticle = "/lg/user_article/delete/";
  static var shareArticle = "/lg/user_article/add/json";

  //获取用户信息
  static var userShareList = "/user/";

  static var navigation = "/navi/json";
  static var systemTree = "/tree/json";
}
