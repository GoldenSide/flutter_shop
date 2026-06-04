/// 购物车 - 单个商品卡片组件
import 'package:flutter/material.dart';
import '../cart_mock.dart';
import 'qty_control.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.onToggleSelect,
    required this.onQtyChanged,
  });

  final CartItem item;
  final VoidCallback onToggleSelect;
  final void Function(int delta) onQtyChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            height: 48,
            child: Checkbox(
              value: item.selected,
              activeColor: const Color(0xFFFF5C4C),
              shape: const CircleBorder(),
              visualDensity: VisualDensity.compact,
              onChanged: (_) => onToggleSelect(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.productPicture,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFEEEEEE),
                  child: const Icon(
                    Icons.image,
                    color: Color(0xFFCCCCCC),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF222222),
                        height: 1.3,
                      ),
                    ),
                  ),
                  if (item.tag != null)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F0),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFFFFE0DC),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        item.tag!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFFF5C4C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    item.spec,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '¥${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFFF5C4C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      QtyControl(
                        quantity: item.quantity,
                        onChanged: onQtyChanged,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
