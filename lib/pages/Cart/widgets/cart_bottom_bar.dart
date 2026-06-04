/// 购物车 - 底部结算栏
///
/// 包含：全选、合计金额、件数统计、结算按钮
/// 通过 [key] 让父组件可以拿到它的位置（用于飞入购物车动画）
import 'package:flutter/material.dart';

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({
    super.key,
    required this.allSelected,
    required this.totalAmount,
    required int kinds,
    required int count,
    required this.onToggleAll,
    required this.onCheckout,
  })  : _kinds = kinds,
        _count = count;

  final bool allSelected;
  final double totalAmount;
  final int _kinds;
  final int _count;
  final void Function(bool?) onToggleAll;
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: 10 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: Checkbox(
              value: allSelected,
              activeColor: const Color(0xFFFF5C4C),
              shape: const CircleBorder(),
              visualDensity: VisualDensity.compact,
              onChanged: onToggleAll,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            '全选',
            style: TextStyle(fontSize: 13, color: Color(0xFF333333)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text.rich(
                  TextSpan(
                    text: '合计：',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                    children: [
                      TextSpan(
                        text: '¥${totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF5C4C),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '共 $_kinds 种 / $_count 件',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onCheckout,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _count == 0
                      ? const [Color(0xFFCCCCCC), Color(0xFFBBBBBB)]
                      : const [Color(0xFFFF7A5C), Color(0xFFFF5C4C)],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: _count == 0
                    ? null
                    : [
                        BoxShadow(
                          color: const Color(0xFFFF5C4C).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Text(
                '结算 ($_count)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
