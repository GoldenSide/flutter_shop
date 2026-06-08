/// 购物车 - 猜你喜欢 单个商品卡片
///
/// 设计要点（解决了两个关键问题）：
/// 1. **数量显示永远是最新的**：每次 build 时通过 `getCount(item)` 回调
///    从父组件（index.dart 的 `_recommendCount`）实时读取。
///    父组件的 `setState` 会触发 `SliverList.builder` 重建卡片 → 新值生效。
/// 2. **动画起点坐标永远是「点击瞬间」的真实坐标**：用 `Builder` 把
///    + 按钮包起来，拿到按钮自己的 `BuildContext`，再通过 `findRenderObject`
///    计算屏幕中心坐标。
///
/// 这是标准的 Flutter 模式：子组件不维护状态，完全由父组件的 map 驱动。
import 'package:flutter/material.dart';
import '../recommend_mock.dart';

class RecommendCard extends StatelessWidget {
  const RecommendCard({
    super.key,
    required this.item,
    required this.maxCount,
    required this.getCount,
    required this.onAddWithPos,
    required this.onMinus,
    required this.onShowToast,
  });

  final RecommendItem item;
  final int maxCount;

  /// 获取当前商品的数量。每次 build 都会调用，保证最新。
  final int Function(RecommendItem item) getCount;

  /// 点击 + 号的回调：传入商品 + 按钮屏幕中心坐标（可能为 null）。
  final void Function(RecommendItem item, Offset? startPos) onAddWithPos;

  /// 点击 - 号的回调（异步，可弹确认删除对话框）。
  final Future<void> Function(RecommendItem item) onMinus;

  final void Function(String msg) onShowToast;

  @override
  Widget build(BuildContext context) {
    final (name, price, img, _shop) = item;
    final count = getCount(item);
    final atMax = count >= maxCount;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(10),
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                img,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, s) => Container(
                  color: const Color(0xFFEEEEEE),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 40,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF333333),
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            child: Row(
              children: [
                Text(
                  '¥${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF5C4C),
                  ),
                ),
                const Spacer(),
                _buildAddButton(context, count, atMax),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, int count, bool atMax) {
    // 未添加：显示单个 + 圆形按钮
    if (count <= 0) {
      return Builder(
        builder: (btnCtx) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              final startPos = _getButtonCenter(btnCtx);
              onAddWithPos(item, startPos);
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFFF5C4C),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33FF5C4C),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.add, size: 16, color: Colors.white),
            ),
          );
        },
      );
    }

    // 已添加：- 数量 + 步进器
    return Container(
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async => await onMinus(item),
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: const Icon(
                Icons.remove,
                size: 14,
                color: Color(0xFFFF5C4C),
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 18),
            alignment: Alignment.center,
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF5C4C),
              ),
            ),
          ),
          Builder(
            builder: (btnCtx) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: atMax
                    ? () => onShowToast('该商品最多添加$maxCount件')
                    : () {
                        final startPos = _getButtonCenter(btnCtx);
                        onAddWithPos(item, startPos);
                      },
                child: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: atMax
                        ? const Color(0xFFCCCCCC)
                        : const Color(0xFFFF5C4C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, size: 14, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 获取按钮的屏幕中心坐标。
  ///
  /// 使用 `context.findRenderObject()` + `localToGlobal(Offset.zero)` 计算。
  /// 拿不到 RenderObject 时返回 null —— 调用方降级为「不加动画，但仍加购」。
  Offset? _getButtonCenter(BuildContext context) {
    try {
      final renderObj = context.findRenderObject();
      if (renderObj == null || renderObj is! RenderBox) return null;
      final size = renderObj.hasSize ? renderObj.size : const Size.square(24);
      final topLeft = renderObj.localToGlobal(Offset.zero);
      final center = Offset(
        topLeft.dx + size.width / 2,
        topLeft.dy + size.height / 2,
      );
      if (center.dx.isNaN || center.dy.isNaN) return null;
      return center;
    } catch (_) {
      return null;
    }
  }
}
