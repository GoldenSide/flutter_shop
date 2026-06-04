/// 购物车 - 数量 ± 控件
///
/// 用于购物车列表中商品的数量增减
import 'package:flutter/material.dart';

class QtyControl extends StatelessWidget {
  const QtyControl({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  final int quantity;
  final void Function(int delta) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qtyButton(Icons.remove, onTap: () => onChanged(-1)),
          Container(
            width: 28,
            alignment: Alignment.center,
            child: Text(
              '$quantity',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF222222),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          _qtyButton(Icons.add, onTap: () => onChanged(1)),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 26,
        height: 24,
        child: Icon(icon, size: 16, color: const Color(0xFF666666)),
      ),
    );
  }
}
