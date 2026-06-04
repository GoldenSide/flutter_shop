/// 购物车 - 猜你喜欢 Mock 数据（含店铺归属）
///
/// 数据结构：
///   (String productName, double price, String imageUrl, String shopName)
///   100 条数据随机归属于 20 个店铺，保证稳定可重现
///
/// 使用方式：
///   import 'package:flutter_dianshang/pages/Cart/recommend_mock.dart';
///
///   List<RecommendItem> items =
///       RecommendMock.fetch(page: 0, pageSize: 6);
///
///   // 异步分页（模拟网络请求）
///   Future<List<RecommendItem>> futureItems =
///       RecommendMock.fetchAsync(page: 0, pageSize: 6);

import 'dart:math';

/// 推荐商品的数据模型
/// productName: 商品名
/// price: 价格
/// imageUrl: 图片 URL
/// shopName: 店铺名（20 个优雅店铺名中随机归属）
typedef RecommendItem = (
  String productName,
  double price,
  String imageUrl,
  String shopName
);

class RecommendMock {
  static const int totalCount = 100;

  // ========== 10 个优雅的店铺名 ==========
  static const List<String> _shopNames = <String>[
    '云帆优品旗舰店',
    '星河造物生活馆',
    '墨香阁精品',
    '草木人间专营店',
    '琉璃雅集',
    '山海造物志',
    '光阴故事',
    '南风知意优选',
    '清风雅物',
    '栖迟优选',
  ];

  // ========== 商品名素材 ==========
  static const List<String> _brands = <String>[
    '华为',
    '小米',
    '荣耀',
    'OPPO',
    'vivo',
    '联想',
    '戴尔',
    '苹果',
    '三星',
    '索尼',
    'Anker',
    '倍思',
    '绿联',
    '罗技',
    '飞利浦',
    '美的',
    '海尔',
    '九阳',
    '三只松鼠',
    '百草味',
  ];

  static const List<String> _keywords = <String>[
    '蓝牙耳机',
    '降噪耳机',
    '智能手表',
    '运动手环',
    '移动电源',
    '充电器',
    'Type-C 数据线',
    '机械键盘',
    '无线鼠标',
    '显示器支架',
    '手机保护壳',
    '钢化膜',
    '高清数据线',
    '便携音箱',
    '蓝牙音响',
    '家用投影仪',
    '智能台灯',
    '桌面风扇',
    '保温杯',
    '玻璃水杯',
    '零食大礼包',
    '坚果礼盒',
    '干果组合',
    '儿童玩具',
    '毛绒玩偶',
    '护肤套装',
    '香水礼盒',
    '运动鞋',
    '休闲鞋',
    '旅行包',
  ];

  static const List<String> _attributes = <String>[
    '高音质',
    '主动降噪',
    '超长续航',
    '旗舰款',
    '青春版',
    '限量版',
    '商务版',
    '轻奢款',
    '经典款',
    '入门精选',
    '热销款',
    '新款上架',
  ];

  // ========== 预生成的稳定 seed 列表（保证同一条商品图片稳定不变化）
  static final List<String> _seeds =
      List<String>.generate(totalCount, (int i) => 'recommend-item-$i');

  // ========== 预生成的店铺索引（保证同一条商品店铺稳定归属同一个店铺）
  static final List<int> _shopIndices = List<int>.generate(
    totalCount,
    (int i) {
      // 用同一个 seed 生成店铺索引，保证稳定
      return Random(i).nextInt(_shopNames.length);
    },
  );

  /// 获取一条稳定的商品（同一条数据每次返回都一样
  static RecommendItem _buildItem(int index) {
    final Random random = Random(index);
    final String brand = _brands[random.nextInt(_brands.length)];
    final String keyword = _keywords[random.nextInt(_keywords.length)];
    final String attribute = _attributes[random.nextInt(_attributes.length)];
    final double price = 19.9 + random.nextInt(2580) + random.nextDouble();
    final String img = 'https://picsum.photos/seed/${_seeds[index]}/600/600';
    final String shopName = _shopNames[_shopIndices[index]];

    final String name = '$brand $attribute $keyword';
    return (name, double.parse(price.toStringAsFixed(2)), img, shopName);
  }

  /// 同步分页获取
  /// [page] 从 0 开始，超过 totalCount 返回空数组
  static List<RecommendItem> fetch({
    required int page,
    required int pageSize,
  }) {
    if (page < 0 || pageSize <= 0) return <RecommendItem>[];
    final int start = page * pageSize;
    if (start >= totalCount) return <RecommendItem>[];
    final int end = (start + pageSize).clamp(0, totalCount);
    return List<RecommendItem>.generate(
      end - start,
      (int i) => _buildItem(start + i),
    );
  }

  /// 异步分页获取（模拟网络请求，400~900ms 随机延迟）
  static Future<List<RecommendItem>> fetchAsync({
    required int page,
    required int pageSize,
    Duration? delay,
  }) async {
    final Duration effectiveDelay =
        delay ?? Duration(milliseconds: 400 + Random().nextInt(500));
    await Future<void>.delayed(effectiveDelay);
    return fetch(page: page, pageSize: pageSize);
  }

  /// 获取总页数
  static int totalPages(int pageSize) =>
      pageSize <= 0 ? 0 : (totalCount / pageSize).ceil();

  /// 获取一个店铺的所有推荐商品（方便调试）
  static List<RecommendItem> fetchByShop(String shopName) {
    final List<RecommendItem> result = <RecommendItem>[];
    for (int i = 0; i < totalCount; i++) {
      final RecommendItem item = _buildItem(i);
      if (item.$4 == shopName) {
        result.add(item);
      }
    }
    return result;
  }
}
