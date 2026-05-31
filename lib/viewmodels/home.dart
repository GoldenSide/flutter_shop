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

// 根据下面注释的 json 编写的特惠推荐数据结构class 并生产对应的工厂方法 factory

class SpecialRecommend {
  final String id;
  final String title;
  final List<SubType> subTypes;

  SpecialRecommend({
    required this.id,
    required this.title,
    required this.subTypes,
  });

  factory SpecialRecommend.fromJson(Map<String, dynamic> json) {
    List<SubType> subTypes = [];
    if (json["subTypes"] != null) {
      final raw = json['subTypes'] as List;
      subTypes =
          raw.map((e) => SubType.fromJson(e as Map<String, dynamic>)).toList();
    }
    return SpecialRecommend(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      subTypes: subTypes,
    );
  }
}

class SubType {
  final String id;
  final String title;
  final GoodsItems goodsItems;

  SubType({
    required this.id,
    required this.title,
    required this.goodsItems,
  });

  factory SubType.fromJson(Map<String, dynamic> json) {
    return SubType(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      goodsItems:
          GoodsItems.fromJson(json["goodsItems"] as Map<String, dynamic>),
    );
  }
}

class GoodsItems {
  final int counts;
  final int pageSize;
  final int pages;
  final int page;
  final List<GoodsItem> items;

  GoodsItems({
    required this.counts,
    required this.pageSize,
    required this.pages,
    required this.page,
    required this.items,
  });

  factory GoodsItems.fromJson(Map<String, dynamic> json) {
    List<GoodsItem> items = [];
    if (json["items"] != null) {
      final raw = json['items'] as List;
      items = raw
          .map((e) => GoodsItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return GoodsItems(
      counts: json["counts"] ?? 0,
      pageSize: json["pageSize"] ?? 0,
      pages: json["pages"] ?? 0,
      page: json["page"] ?? 0,
      items: items,
    );
  }
}

class GoodsItem {
  final String id;
  final String name;
  final String? desc;
  final String price;
  final String picture;
  final int orderNum;

  GoodsItem({
    required this.id,
    required this.name,
    this.desc,
    required this.price,
    required this.picture,
    required this.orderNum,
  });

  factory GoodsItem.fromJson(Map<String, dynamic> json) {
    return GoodsItem(
      id: json["id"].toString() ?? "",
      name: json["name"] ?? "",
      desc: json["desc"] ?? null,
      price: json["price"].toString() ?? "",
      picture: json["picture"] ?? "",
      orderNum: json["orderNum"] ?? 0,
    );
  }
}

class GoodsDetailItem extends GoodsItem {
  int payCount = 0;

  GoodsDetailItem({
    required super.id,
    required super.name,
    required super.price,
    required super.picture,
    required super.orderNum,
    required this.payCount,
  }) : super(desc: '');
  factory GoodsDetailItem.fromJson(Map<String, dynamic> json) {
    return GoodsDetailItem(
      id: json["id"].toString() ?? "",
      name: json["name"] ?? "",
      price: json["price"].toString() ?? "",
      picture: json["picture"] ?? "",
      orderNum: json["orderNum"] ?? 0,
      payCount: json["payCount"] ?? 0,
    );
  }
}
