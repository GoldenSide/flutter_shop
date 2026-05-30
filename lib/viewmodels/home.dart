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

// 根据注释的 json 编写的分类数据结构
class Category {
  final String id;
  final String name;
  final String picture;
  final List<Category>? children;
  final List<dynamic>? goods;

  Category({
    required this.id,
    required this.name,
    required this.picture,
    this.children,
    this.goods,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    List<Category>? children;
    if (json["children"] != null) {
      final raw = json["children"] as List;
      children =
          raw.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
    }

    List<dynamic>? goods;
    if (json.containsKey("goods") && json["goods"] != null) {
      goods = json["goods"] as List<dynamic>?;
    }

    return Category(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      picture: json["picture"] ?? "",
      children: children,
      goods: goods,
    );
  }
}
