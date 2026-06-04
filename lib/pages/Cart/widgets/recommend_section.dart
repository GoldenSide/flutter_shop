/// 购物车 - 猜你喜欢 整体区域
///
/// 包含：标题 + 两列商品卡片网格 + 底部状态（到底啦）
/// 此组件不负责状态管理，所有数据通过 props 传入。
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

  /// 获取某件商品当前已添加的数量
  final int Function(RecommendItem item) getCount;

  /// 点击 + 号时的回调：startPos 为 + 按钮中心点的屏幕坐标，可能为 null
  final void Function(RecommendItem item, Offset? startPos) onAddWithPos;

  /// 点击 - 号时的回调（异步，可在内部弹对话框确认删除）
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

    // 如果不渲染标题，childCount = 商品行数 + 底部 1 行
    // 如果渲染标题，childCount = 标题 1 + 商品行数 + 底部 1
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
                    currentCount: getCount(left),
                    maxCount: maxCountPerItem,
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
                          currentCount: getCount(right),
                          maxCount: maxCountPerItem,
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
        childCount: () {
          if (rows.isEmpty) return titleOffset + 1;
          return titleOffset + rows.length + 1;
        }(),
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
