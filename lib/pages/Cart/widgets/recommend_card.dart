/// 购物车 - 猜你喜欢 单个商品卡片
///
/// 包含：商品图片、名称、价格、数量 ± 控件
/// 点击 + 按钮时：
///   1. 立即调用 onAddWithPos（父组件 setState → 数量 UI 更新）
///   2. 同步计算 + 按钮中心点（用于飞入购物车动画）
///      计算失败时降级为「传 null，不加动画」，但**不会**阻塞加购
import 'package:flutter/material.dart';
import '../recommend_mock.dart';

class RecommendCard extends StatelessWidget {
  const RecommendCard({
    super.key,
    required this.item,
    required this.currentCount,
    required this.maxCount,
    required this.onAddWithPos,
    required this.onMinus,
    required this.onShowToast,
  });

  final RecommendItem item;
  final int currentCount;
  final int maxCount;

  /// + 按钮回调：item + 起点坐标（坐标为 null 时降级为无动画加购）
  final void Function(RecommendItem item, Offset? startPos) onAddWithPos;

  /// - 按钮回调（异步，可在内部弹确认删除对话框）
  final Future<void> Function(RecommendItem item) onMinus;
  final void Function(String msg) onShowToast;

  @override
  Widget build(BuildContext context) {
    final (name, price, img, _shop) = item;
    final atMax = currentCount >= maxCount;

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
                _buildAddButton(
                  context: context,
                  item: item,
                  count: currentCount,
                  atMax: atMax,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 加号 / 步进器按钮组
  ///
  /// 注意：
  ///   + 按钮外层包了一个 Builder，保证拿到的 BuildContext 就是
  ///   这个按钮自己的 context，而不是整张卡片的 context。
  ///   这样 `_getButtonCenter` 才能拿到准确的 + 按钮中心点，
  ///   从而驱动飞入购物车动画。
  Widget _buildAddButton({
    required BuildContext context,
    required RecommendItem item,
    required int count,
    required bool atMax,
  }) {
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

    // 已添加：显示「- 数量 +」步进器
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

  /// 获取 + 按钮的屏幕中心点坐标
  ///
  /// 使用 `context.findRenderObject()` 获取按钮所在 RenderObject，
  /// 再用 `localToGlobal(Offset.zero)` 得到左上角的屏幕坐标，最后
  /// 加上宽高的一半得到中心点。
  ///
  /// 如果拿不到 RenderObject，降级返回 null —— 调用方会走「不加动画
  /// 但仍然加购」的分支，**保证加购逻辑永远优先于动画**。
  Offset? _getButtonCenter(BuildContext context) {
    try {
      final renderObj = context.findRenderObject();
      if (renderObj == null || renderObj is! RenderBox) return null;
      // 若 widget 尚未完成 layout，hasSize 可能为 false → 降级用标称 24
      final size = renderObj.hasSize ? renderObj.size : const Size.square(24);
      final topLeft = renderObj.localToGlobal(Offset.zero);
      final center = Offset(
        topLeft.dx + size.width / 2,
        topLeft.dy + size.height / 2,
      );
      // 避免出现 NaN / 无穷大坐标（理论上不会出现，但防御一下）
      if (center.dx.isNaN || center.dy.isNaN) return null;
      return center;
    } catch (_) {
      return null;
    }
  }
}
