/// 购物车 - 猜你喜欢 整体区域
///
/// 包含：标题 + 两列商品卡片网格 + 底部状态（到底啦）。
/// 每个商品卡片（RecommendCard）内部维护自己的数量状态，本组件不负责。
import 'package:flutter/material.dart';
import '../recommend_mock.dart';
import 'recommend_card.dart';

class RecommendSection extends StatelessWidget {
  const RecommendSection({
    super.key,
    required this.items,
    required this.hasMore,
    required this.maxCountPerItem,
    required this.getCount,
    required this.onAddWithPos,
    required this.onMinus,
    required this.onShowToast,
    this.showHeader = true,
  });

  final List<RecommendItem> items;
  final bool hasMore;
  final int maxCountPerItem;
  final bool showHeader;

  /// 读取某个推荐商品当前的数量（build 时实时调用，返回最新值）。
  final int Function(RecommendItem item) getCount;

  /// 点击 + 号的回调，startPos 为按钮屏幕中心坐标（可能为 null）。
  /// 调用时，卡片内部的 optimistic 已 +1。
  final void Function(RecommendItem item, Offset? startPos) onAddWithPos;

  /// 点击 - 号的回调（异步，可在内部弹对话框确认删除）。
  final Future<void> Function(RecommendItem item) onMinus;

  final void Function(String msg) onShowToast;

  @override
  Widget build(BuildContext context) {
    final rows = <List<RecommendItem>>[];
    for (int i = 0; i < items.length; i += 2) {
      rows.add(items.sublist(
        i,
        (i + 2 <= items.length) ? i + 2 : items.length,
      ));
    }

    final titleOffset = showHeader ? 1 : 0;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (showHeader && index == 0) {
            return const RecommendHeader();
          }
          final rowIndex = index - titleOffset;
          if (rowIndex == rows.length) {
            return const RecommendFooter();
          }
          final row = rows[rowIndex];
          final left = row.first;
          final right = row.length >= 2 ? row[1] : null;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RecommendCard(
                    item: left,
                    maxCount: maxCountPerItem,
                    getCount: getCount,
                    onAddWithPos: onAddWithPos,
                    onMinus: onMinus,
                    onShowToast: onShowToast,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: right != null
                      ? RecommendCard(
                          item: right,
                          maxCount: maxCountPerItem,
                          getCount: getCount,
                          onAddWithPos: onAddWithPos,
                          onMinus: onMinus,
                          onShowToast: onShowToast,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
        childCount:
            rows.isEmpty ? titleOffset + 1 : titleOffset + rows.length + 1,
      ),
    );
  }
}

/// 猜你喜欢 标题（被吸顶场景复用）
class RecommendHeader extends StatelessWidget {
  const RecommendHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(4, 4, 4, 12),
      child: Text(
        '猜你喜欢',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF222222),
        ),
      ),
    );
  }
}

/// 猜你喜欢 底部状态
class RecommendFooter extends StatelessWidget {
  const RecommendFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          '—— 已经到底啦 ——',
          style: TextStyle(fontSize: 12, color: Color(0xFFBBBBBB)),
        ),
      ),
    );
  }
}
