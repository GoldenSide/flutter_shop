import 'package:flutter_dianshang/viewmodels/home.dart';

class GuessGoodsItems {
  final int counts;
  final int pageSize;
  final int pages;
  final int page;
  final List<GoodsDetailItem> items;

  GuessGoodsItems({
    required this.counts,
    required this.pageSize,
    required this.pages,
    required this.page,
    required this.items,
  });

  factory GuessGoodsItems.fromJson(Map<String, dynamic> json) {
    List<GoodsDetailItem> items = [];
    if (json["items"] != null) {
      final raw = json['items'] as List;
      items = raw
          .map((e) => GoodsDetailItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return GuessGoodsItems(
      counts: json["counts"] ?? 0,
      pageSize: json["pageSize"] ?? 0,
      pages: json["pages"] ?? 0,
      page: json["page"] ?? 0,
      items: items,
    );
  }
}
