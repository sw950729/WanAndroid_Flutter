class MineItemEntity {
  String leftIconData;
  String title;

  MineItemEntity({this.leftIconData, this.title});

  MineItemEntity.fromJson(Map<String, dynamic> json) {
    leftIconData = json['leftIconData'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leftIconData'] = this.leftIconData;
    data['title'] = this.title;
    return data;
  }
}
