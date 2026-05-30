// Banner 轮播图的数据结构
class BannerItem {
  final String imgUrl;
  final String id;
  BannerItem({required this.imgUrl, required this.id});
  factory BannerItem.formJSON(Map<String, dynamic> json) {
    // 必须返回一个BannerItem对象
    return BannerItem(id: json["id"] ?? "", imgUrl: json["imgUrl"] ?? "");
  }
}
