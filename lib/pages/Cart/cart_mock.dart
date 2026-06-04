/// 购物车 - Mock 数据（独立文件）
///
/// 包含:
///   - [CartItem] 购物车商品数据模型
///   - [CartMock] 购物车假数据生成器
///
/// 使用:
///   import 'package:flutter_dianshang/pages/Cart/cart_mock.dart';
///   List<CartItem> items = CartMock.generate();

class CartItem {
  final String id;
  final String shopName;
  final String productId;
  final String productName;
  final String productPicture;
  final String spec;
  double price;
  int quantity;
  bool selected;
  final String? tag;

  CartItem({
    required this.id,
    required this.shopName,
    required this.productId,
    required this.productName,
    required this.productPicture,
    required this.spec,
    required this.price,
    required this.quantity,
    this.selected = true,
    this.tag,
  });

  /// ==== 工厂函数：从推荐商品创建 CartItem ====
  /// 推荐商品的店铺会在上方购物车分组中按 shopName 展示
  factory CartItem.fromRecommend({
    required String recommendKey,
    required String name,
    required double price,
    required String imageUrl,
    required int quantity,
    required String shopName,
    String tag = '推荐',
  }) {
    return CartItem(
      id: 'recommend_$recommendKey',
      shopName: shopName,
      productId: 'rec_$recommendKey',
      productName: name,
      productPicture: imageUrl,
      spec: '热门推荐',
      price: price,
      quantity: quantity,
      selected: true,
      tag: tag,
    );
  }

  /// 辅助：从 4 字段 recommend record 快速创建
  static CartItem fromRecommendRecord(
    (String, double, String, String) record,
    int quantity, {
    String tag = '推荐',
  }) {
    return CartItem.fromRecommend(
      recommendKey: record.$3,
      name: record.$1,
      price: record.$2,
      imageUrl: record.$3,
      quantity: quantity,
      shopName: record.$4,
      tag: tag,
    );
  }
}

class CartMock {
  /// 生成一份固定的购物车 Mock 数据
  static List<CartItem> generate() {
    return [
      CartItem(
        id: 'cart_001',
        shopName: '优选旗舰店',
        productId: 'p_001',
        productName: 'Apple 苹果 iPhone 15 Pro Max 256GB 原色钛金属 5G手机',
        productPicture: 'https://picsum.photos/seed/phone-iphone/600/600',
        spec: '原色钛金属 / 256GB',
        price: 8999.00,
        quantity: 1,
        tag: '官方推荐',
      ),
      CartItem(
        id: 'cart_002',
        shopName: '优选旗舰店',
        productId: 'p_002',
        productName: 'Apple AirPods Pro (第二代) 配 MagSafe 充电盒 (USB-C) 蓝牙耳机',
        productPicture: 'https://picsum.photos/seed/earphone-airpods/600/600',
        spec: 'USB-C 接口版',
        price: 1699.00,
        quantity: 2,
      ),
      CartItem(
        id: 'cart_003',
        shopName: '潮流数码专营店',
        productId: 'p_003',
        productName: '小米14 Ultra 徕卡光学Summilux镜头 大师人像 双向卫星通信 16GB+512GB 白色',
        productPicture: 'https://picsum.photos/seed/phone-xiaomi/600/600',
        spec: '白色 / 16GB+512GB',
        price: 6499.00,
        quantity: 1,
        tag: '热卖',
      ),
      CartItem(
        id: 'cart_004',
        shopName: '潮流数码专营店',
        productId: 'p_004',
        productName: '华为 HUAWEI Mate 60 Pro 12GB+512GB 雅川青 卫星通话 玄武架构',
        productPicture: 'https://picsum.photos/seed/phone-huawei/600/600',
        spec: '雅川青 / 12GB+512GB',
        price: 7499.00,
        quantity: 1,
        tag: '新品',
      ),
      CartItem(
        id: 'cart_005',
        shopName: '家居优选生活馆',
        productId: 'p_005',
        productName: '三只松鼠零食大礼包每日坚果组合装混合装零食小吃休闲食品一整箱',
        productPicture: 'https://picsum.photos/seed/food-snack/600/600',
        spec: '大礼包 / 1.5kg',
        price: 99.90,
        quantity: 3,
        tag: '特惠',
      ),
    ];
  }

  /// 生成一份空购物车（用于测试空状态）
  static List<CartItem> empty() => <CartItem>[];
}
