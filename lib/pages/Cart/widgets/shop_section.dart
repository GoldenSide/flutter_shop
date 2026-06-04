/// 购物车 - 店铺分组卡片
///
/// 同一店铺的商品会被放到一个卡片里。每个卡片包含：
///   - 店铺 Header：选择框 + 店铺名 + 箭头，可独立选中
///   - 商品列表：若干个 [CartItemCard]
import 'package:flutter/material.dart';
import '../cart_mock.dart';
import 'item_card.dart';

class ShopSection extends StatelessWidget {
  const ShopSection({
    super.key,
    required this.shopName,
    required this.items,
    required this.onToggleSelect,
    required this.onQtyChanged,
    required this.onToggleShop,
  });

  final String shopName;
  final List<CartItem> items;
  final void Function(CartItem item) onToggleSelect;
  final Future<void> Function(CartItem item, int delta) onQtyChanged;
  final void Function(bool value) onToggleShop;

  bool get _shopAllSelected => items.every((e) => e.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: _shopAllSelected,
                    activeColor: const Color(0xFFFF5C4C),
                    shape: const CircleBorder(),
                    visualDensity: VisualDensity.compact,
                    onChanged: (value) => onToggleShop(value ?? false),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000).withOpacity(0.06),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.store,
                    size: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    shopName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Color(0xFF999999),
                ),
              ],
            ),
          ),
          ...items.map((item) => CartItemCard(
                item: item,
                onToggleSelect: () => onToggleSelect(item),
                onQtyChanged: (delta) async => await onQtyChanged(item, delta),
              )),
        ],
      ),
    );
  }
}
