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
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      desc: json["desc"] ?? null,
      price: json["price"] ?? "",
      picture: json["picture"] ?? "",
      orderNum: json["orderNum"] ?? 0,
    );
  }
}

// {
//     "code": "1",
//     "msg": "操作成功",
//     "result": {
//         "id": "897682543",
//         "title": "特惠推荐",
//         "subTypes": [
//             {
//                 "id": "912000341",
//                 "title": "抢先尝鲜",
//                 "goodsItems": {
//                     "counts": 459,
//                     "pageSize": 10,
//                     "pages": 46,
//                     "page": 1,
//                     "items": [
//                         {
//                             "id": "1750713979950333956",
//                             "name": "Balva 日本制高级时尚太阳镜 方框",
//                             "desc": "抵挡99%紫外线太阳镜",
//                             "price": "1213.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/235220/p5.png",
//                             "orderNum": 17
//                         },
//                         {
//                             "id": "1750713979895808015",
//                             "name": "COGIT UV休闲百搭牛仔帽 深蓝色",
//                             "desc": "不压发型 清凉舒适",
//                             "price": "116.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/250541/p3.png",
//                             "orderNum": 18
//                         },
//                         {
//                             "id": "1750713979900002316",
//                             "name": "CA4LA AKA SIX CHECK TRAPPER HAT ORANGE ONESIZE 货号:MOR00097",
//                             "desc": "暖色格调飞行帽",
//                             "price": "1809.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/254345/p1.png",
//                             "orderNum": 10
//                         },
//                         {
//                             "id": "1750713979652538372",
//                             "name": "ROOTOTE DELI 个性时尚大容量手提包 黑色豹纹",
//                             "desc": "大容量实用手提包",
//                             "price": "298.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/250011/p5.png",
//                             "orderNum": 13
//                         },
//                         {
//                             "id": "1750713979929362433",
//                             "name": "手袋动物园 防寒保暖可爱动物手套 咖色小熊",
//                             "desc": "两用保暖动物小手套",
//                             "price": "198.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/238258/p1.png",
//                             "orderNum": 13
//                         },
//                         {
//                             "id": "1750713979203747840",
//                             "name": "CU2 舒适减负背包 紫色",
//                             "desc": "舒适轻松实现大容量出行",
//                             "price": "2419.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/255004/p1.png",
//                             "orderNum": 25
//                         },
//                         {
//                             "id": "1750713979900002312",
//                             "name": "kaorinomori 毛边针织条带帽Bebe黑色 56cm～58cm(97)",
//                             "desc": "秋冬必备萌系帽",
//                             "price": "537.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/256104/p9.png",
//                             "orderNum": 9
//                         },
//                         {
//                             "id": "1750713979900002317",
//                             "name": "CA4LA CHARI3 CHARCOAL GRAY ONESIZE 货号:TAM02605",
//                             "desc": "温暖实用，型格百搭",
//                             "price": "787.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/254354/p1.png",
//                             "orderNum": 8
//                         },
//                         {
//                             "id": "1750713979925168129",
//                             "name": "KNITTING INN 羊毛毛毡格纹围巾 赤褐色",
//                             "desc": "厚实柔软有弹性",
//                             "price": "1019.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/42590/p1.png",
//                             "orderNum": 15
//                         },
//                         {
//                             "id": "1379052170040578049",
//                             "name": "极光限定 珠光蓝珐琅锅",
//                             "desc": null,
//                             "price": "199.00",
//                             "picture": "http://yjy-xiaotuxian-dev.oss-cn-beijing.aliyuncs.com/picture/2021-04-05/7f483771-6831-4a7a-abdb-2625acb755f3.png",
//                             "orderNum": 929
//                         }
//                     ]
//                 }
//             },
//             {
//                 "id": "912000342",
//                 "title": "新品预告",
//                 "goodsItems": {
//                     "counts": 459,
//                     "pageSize": 10,
//                     "pages": 46,
//                     "page": 1,
//                     "items": [
//                         {
//                             "id": "1750713979900002312",
//                             "name": "kaorinomori 毛边针织条带帽Bebe黑色 56cm～58cm(97)",
//                             "desc": "秋冬必备萌系帽",
//                             "price": "537.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/256104/p9.png",
//                             "orderNum": 9
//                         },
//                         {
//                             "id": "1750713979929362433",
//                             "name": "手袋动物园 防寒保暖可爱动物手套 咖色小熊",
//                             "desc": "两用保暖动物小手套",
//                             "price": "198.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/238258/p1.png",
//                             "orderNum": 13
//                         },
//                         {
//                             "id": "1750713979950333956",
//                             "name": "Balva 日本制高级时尚太阳镜 方框",
//                             "desc": "抵挡99%紫外线太阳镜",
//                             "price": "1213.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/235220/p5.png",
//                             "orderNum": 17
//                         },
//                         {
//                             "id": "1750713979900002316",
//                             "name": "CA4LA AKA SIX CHECK TRAPPER HAT ORANGE ONESIZE 货号:MOR00097",
//                             "desc": "暖色格调飞行帽",
//                             "price": "1809.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/254345/p1.png",
//                             "orderNum": 10
//                         },
//                         {
//                             "id": "1750713979925168129",
//                             "name": "KNITTING INN 羊毛毛毡格纹围巾 赤褐色",
//                             "desc": "厚实柔软有弹性",
//                             "price": "1019.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/42590/p1.png",
//                             "orderNum": 15
//                         },
//                         {
//                             "id": "1379052170040578049",
//                             "name": "极光限定 珠光蓝珐琅锅",
//                             "desc": null,
//                             "price": "199.00",
//                             "picture": "http://yjy-xiaotuxian-dev.oss-cn-beijing.aliyuncs.com/picture/2021-04-05/7f483771-6831-4a7a-abdb-2625acb755f3.png",
//                             "orderNum": 929
//                         },
//                         {
//                             "id": "1750713979895808015",
//                             "name": "COGIT UV休闲百搭牛仔帽 深蓝色",
//                             "desc": "不压发型 清凉舒适",
//                             "price": "116.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/250541/p3.png",
//                             "orderNum": 18
//                         },
//                         {
//                             "id": "1750713979652538372",
//                             "name": "ROOTOTE DELI 个性时尚大容量手提包 黑色豹纹",
//                             "desc": "大容量实用手提包",
//                             "price": "298.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/250011/p5.png",
//                             "orderNum": 13
//                         },
//                         {
//                             "id": "1750713979900002317",
//                             "name": "CA4LA CHARI3 CHARCOAL GRAY ONESIZE 货号:TAM02605",
//                             "desc": "温暖实用，型格百搭",
//                             "price": "787.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/254354/p1.png",
//                             "orderNum": 8
//                         },
//                         {
//                             "id": "1750713979203747840",
//                             "name": "CU2 舒适减负背包 紫色",
//                             "desc": "舒适轻松实现大容量出行",
//                             "price": "2419.00",
//                             "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/255004/p1.png",
//                             "orderNum": 25
//                         }
//                     ]
//                 }
//             }
//         ]
//     }
// }
