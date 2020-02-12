import 'package:silence_wan_android/entity/HomeArticleListEntity.dart';

/// @date:2020-02-11
/// @author:Silence
/// @describe:
class UserShareEntity {
  CoinInfo coinInfo;
  HomeArticleListEntity shareArticles;

  UserShareEntity({this.coinInfo, this.shareArticles});

  UserShareEntity.fromJson(Map<String, dynamic> json) {
    coinInfo = json['coinInfo'] != null
        ? new CoinInfo.fromJson(json['coinInfo'])
        : null;
    shareArticles = json['shareArticles'] != null
        ? new HomeArticleListEntity.fromJson(json['shareArticles'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coinInfo != null) {
      data['coinInfo'] = this.coinInfo.toJson();
    }
    if (this.shareArticles != null) {
      data['shareArticles'] = this.shareArticles.toJson();
    }
    return data;
  }
}

class CoinInfo {
  int coinCount;
  int level;
  int rank;
  int userId;
  String username;

  CoinInfo({this.coinCount, this.level, this.rank, this.userId, this.username});

  CoinInfo.fromJson(Map<String, dynamic> json) {
    coinCount = json['coinCount'];
    level = json['level'];
    rank = json['rank'];
    userId = json['userId'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coinCount'] = this.coinCount;
    data['level'] = this.level;
    data['rank'] = this.rank;
    data['userId'] = this.userId;
    data['username'] = this.username;
    return data;
  }
}
