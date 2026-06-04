/// 购物车 - 主入口
///
/// 组件拆分：
///   - [cart_mock.dart]        购物车商品数据模型 + Mock
///   - [recommend_mock.dart]   推荐商品数据模型 + Mock（100条，20个店铺）
///   - [widgets/cart_header.dart]       顶部 Header
///   - [widgets/cart_empty.dart]        空状态
///   - [widgets/shop_section.dart]      店铺分组卡片
///   - [widgets/item_card.dart]         商品卡片
///   - [widgets/qty_control.dart]       数量 ± 控件
///   - [widgets/recommend_section.dart] 猜你喜欢整体区域
///   - [widgets/recommend_card.dart]    推荐商品卡片（含计数器）
///   - [widgets/cart_bottom_bar.dart]   底部结算栏
///
/// 本文件（index.dart）负责：状态管理、动画、渲染逻辑组合、事件回调转发
import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import 'cart_mock.dart';
import 'recommend_mock.dart';
import 'widgets/cart_header.dart';
import 'widgets/cart_empty.dart';
import 'widgets/shop_section.dart';
import 'widgets/cart_bottom_bar.dart';
import 'widgets/recommend_section.dart' show RecommendSection, RecommendHeader;

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView>
    with SingleTickerProviderStateMixin {
  // ========== 购物车商品（固定 5 件 Mock）==========
  late List<CartItem> _items;

  // ========== 猜你喜欢 - 预加载（每次 6 条，共 100 条）==========
  static const int _recommendPageSize = 6;
  final ScrollController _scrollController = ScrollController();
  final List<RecommendItem> _recommendItems = <RecommendItem>[];
  int _recommendPage = 0;
  bool _isLoadingRecommend = false;
  bool _hasMoreRecommend = true;

  // ========== 推荐商品计数器（每个商品独立计数，最多 5 件）==========
  /// key = 推荐商品图片 URL（唯一标识），value = 持久化的 CartItem 对象
  /// 这张表只负责「用户在推荐区点击过 +」——它会立刻被写入，驱动卡片 UI 上的
  /// 「圆形 + / 步进器」切换以及底部结算栏的金额计算；但**不直接**让商品出现在上方购物车列表里
  Map<String, CartItem> _recommendCartItemMap = <String, CartItem>{};

  /// 已经「确认落库」的推荐商品。只有动画播放完成（或用户主动再点一次）才会出现在
  /// 上方列表里。这么做是为了保证：
  ///   1. 点击 + 的瞬间，推荐卡片位置不变（不会被上方列表新增的商品推下去）
  ///   2. 动画起点坐标是「点击瞬间」的真实坐标
  ///   3. 动画播完，再把商品正式塞进上方购物车列表
  Map<String, CartItem> _recommendConfirmedMap = <String, CartItem>{};

  static const int _maxRecommendCount = 5;

  // ========== 飞入购物车动画 ==========
  AnimationController? _dropAnimController;
  OverlayEntry? _dropOverlayEntry;
  final Curve _dropCurve = Curves.easeOutCubic;
  static const int _dropAnimMs = 900;
  // 底部结算栏 key，用于动画终点定位
  final GlobalKey _bottomBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _items = CartMock.generate();
    _scrollController.addListener(_onScroll);
    _dropAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _dropAnimMs),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMoreRecommend();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _dropAnimController?.dispose();
    super.dispose();
  }

  // ========== 滚动 + 预加载 ==========
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    // 提前 1 屏高度触发加载，用户滑到底部时数据已就绪
    if (pos.pixels >= pos.maxScrollExtent - pos.viewportDimension) {
      _loadMoreRecommend();
    }
  }

  Future<void> _loadMoreRecommend() async {
    if (_isLoadingRecommend || !_hasMoreRecommend) return;
    _isLoadingRecommend = true;
    try {
      final page = _recommendPage;
      final list = await RecommendMock.fetchAsync(
        page: page,
        pageSize: _recommendPageSize,
      );
      if (!mounted) return;
      setState(() {
        _recommendItems.addAll(list);
        _recommendPage = page + 1;
        _isLoadingRecommend = false;
        if (list.length < _recommendPageSize ||
            _recommendItems.length >= RecommendMock.totalCount) {
          _hasMoreRecommend = false;
        }
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingRecommend = false;
        });
      }
    }
  }

  // ========== 购物车 + 已添加推荐商品 合并 ==========
  /// 已「确认落库」的推荐商品（播完动画或二次点击）才会出现在上方列表里
  List<CartItem> get _recommendConfirmedItems =>
      _recommendConfirmedMap.values.toList();

  /// 真正渲染在上方列表里的购物车商品
  List<CartItem> get _mergedItems => [..._items, ..._recommendConfirmedItems];

  /// 用于**底部结算栏**金额计算：用户点过 + 的所有推荐商品都要纳入
  /// （即使还没完成飞入动画，也应该"算进去"）
  List<CartItem> get _checkoutItems => [
        ..._items,
        ..._recommendCartItemMap.values,
      ];

  // ========== 合计计算 ==========
  int get _selectedCount => _checkoutItems
      .where((e) => e.selected)
      .fold(0, (sum, e) => sum + e.quantity);

  double get _selectedAmount => _checkoutItems
      .where((e) => e.selected)
      .fold(0.0, (sum, e) => sum + e.price * e.quantity);

  int get _selectedKinds => _checkoutItems.where((e) => e.selected).length;

  bool get _allSelected =>
      _checkoutItems.isNotEmpty && _checkoutItems.every((e) => e.selected);

  // ========== 选择 & 数量变更 ==========
  void _toggleAll(bool? value) {
    setState(() {
      for (var item in _mergedItems) {
        item.selected = value ?? false;
      }
    });
  }

  void _toggleSelect(CartItem item) {
    setState(() {
      item.selected = !item.selected;
    });
  }

  /// 更新数量 / 删除商品
  ///   - delta == 1：数量 +1（上限 99）
  ///   - delta == -1：数量 > 1 时 -1；数量 == 1 时弹确认删除对话框
  ///
  /// 说明：由于推荐商品（来自 recommend_card）和购物车商品（来自 item_card）
  /// 的数据存储位置不同（一个在 _recommendCartItemMap，一个在 _items），
  /// 我们通过对象引用 + id 统一处理，这样结算区的 _selectedCount /
  /// _selectedAmount / _selectedKinds / _allSelected 都会实时更新。
  Future<void> _updateQty(CartItem item, int delta) async {
    // 点击「-」且当前数量已经是 1：弹确认删除
    if (delta < 0 && item.quantity <= 1) {
      final confirmed = await _showDeleteConfirmDialog(item);
      if (confirmed != true) return;
      _removeItem(item);
      return;
    }
    // 普通增减
    setState(() {
      item.quantity = (item.quantity + delta).clamp(1, 99);
    });
  }

  /// 从购物车 / 推荐购物车中移除指定商品
  void _removeItem(CartItem item) {
    setState(() {
      // 原始购物车商品
      _items.removeWhere((e) => e.id == item.id);
      // 推荐商品购物车
      _recommendCartItemMap.removeWhere(
        (key, value) => value.id == item.id,
      );
    });
  }

  /// 确认删除对话框
  Future<bool?> _showDeleteConfirmDialog(CartItem item) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('删除确认', style: TextStyle(fontSize: 16)),
          content: Text('确定要从购物车中删除「${item.productName}」吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child:
                  const Text('取消', style: TextStyle(color: Color(0xFF999999))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5C4C),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );
  }

  // ========== 推荐商品 key & 数量 ==========
  String _recommendKey(RecommendItem item) => item.$3;
  int _recommendCount(RecommendItem item) =>
      _recommendCartItemMap[_recommendKey(item)]?.quantity ?? 0;

  Future<void> _onAddRecommendItem(
    RecommendItem item,
    Offset? startOffset,
  ) async {
    final key = _recommendKey(item);
    final existing = _recommendCartItemMap[key];
    final currentCount = existing?.quantity ?? 0;

    if (currentCount >= _maxRecommendCount) {
      _showToast('该商品最多添加$_maxRecommendCount件');
      return;
    }

    // 是否为首次添加（0 → 1）
    final isFirstAdd = currentCount == 0;

    // ========== 核心：同步 setState，立刻更新 UI ==========
    // 必须同步更新数量 / 合并购物车数据，否则计数器不会立刻变
    setState(() {
      // 构造一个新的 Map，避免子组件因 Map 引用未变而误判为未变化
      final nextMap = Map<String, CartItem>.from(_recommendCartItemMap);
      if (existing != null) {
        nextMap[key] = existing..quantity = currentCount + 1;
      } else {
        final (name, price, img, shopName) = item;
        nextMap[key] = CartItem.fromRecommend(
          recommendKey: key,
          name: name,
          price: price,
          imageUrl: img,
          quantity: 1,
          shopName: shopName,
        );
      }
      _recommendCartItemMap = nextMap;
    });

    // ========== 首次添加：播放飞入购物车动画（异步，不阻塞 UI） ==========
    if (isFirstAdd && startOffset != null && mounted) {
      // 在当前 frame 完成后再启动动画，避免与 build 冲突
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        unawaited(_playDropToCartAnimation(startOffset!));
      });
    }
  }

  Future<void> _onMinusRecommendItem(RecommendItem item) async {
    final key = _recommendKey(item);
    final existing = _recommendCartItemMap[key];
    if (existing == null) return;

    // 当前数量 == 1：点击「-」视为请求删除，走统一的确认对话框
    if (existing.quantity <= 1) {
      final confirmed = await _showDeleteConfirmDialog(existing);
      if (confirmed != true) return;
      setState(() {
        _recommendCartItemMap =
            Map<String, CartItem>.from(_recommendCartItemMap)..remove(key);
      });
      return;
    }

    // 数量 > 1：普通减 1
    setState(() {
      _recommendCartItemMap = Map<String, CartItem>.from(_recommendCartItemMap)
        ..[key] = existing
        ..quantity = existing.quantity - 1;
    });
  }

  // ========== Toast ==========
  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.25,
          vertical: 24,
        ),
      ),
    );
  }

  // ========== 飞入购物车动画 ==========
  Future<void> _playDropToCartAnimation(Offset start) async {
    final controller = _dropAnimController;
    if (controller == null) return;

    // 如果正在播放动画，先清理
    if (controller.isAnimating || controller.value > 0) {
      controller.reset();
      _removeDropOverlay();
    }

    // 计算终点位置（底部结算栏右侧）
    Offset endOffset;
    final barCtx = _bottomBarKey.currentContext;
    if (barCtx != null) {
      final barBox = barCtx.findRenderObject() as RenderBox?;
      if (barBox != null) {
        final barPos = barBox.localToGlobal(Offset.zero);
        final barSize = barBox.size;
        endOffset = Offset(
          barPos.dx + barSize.width * 0.85,
          barPos.dy + barSize.height / 2,
        );
      } else {
        final screenSize = MediaQuery.of(context).size;
        endOffset = Offset(screenSize.width * 0.85, screenSize.height - 40);
      }
    } else {
      final screenSize = MediaQuery.of(context).size;
      endOffset = Offset(screenSize.width * 0.85, screenSize.height - 40);
    }

    // 获取 Overlay
    OverlayState? overlayState;
    try {
      overlayState = Overlay.of(context);
    } catch (_) {
      overlayState = null;
    }
    if (overlayState == null) return;

    // 创建 OverlayEntry（小球）
    final overlayEntry = OverlayEntry(
      builder: (ctx) {
        return AnimatedBuilder(
          animation: controller,
          builder: (ctx, child) {
            final t = _dropCurve.transform(controller.value);
            final dx = start.dx + (endOffset.dx - start.dx) * t;
            // 抛物线：先上升再下落
            const peak = 80.0;
            final parabola = -peak * 4 * t * (1 - t);
            final dy = start.dy + (endOffset.dy - start.dy) * t + parabola;
            final scale = 1.0 - 0.75 * t;
            final opacity = t < 0.7 ? 1.0 : (1.0 - (t - 0.7) / 0.3);

            return Positioned(
              left: dx - 18,
              top: dy - 18,
              width: 36,
              height: 36,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5C4C),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x66FF5C4C),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    _dropOverlayEntry = overlayEntry;
    overlayState.insert(overlayEntry);

    // 播放动画
    try {
      await controller.forward(from: 0.0).orCancel;
    } catch (_) {}
    _removeDropOverlay();
  }

  void _removeDropOverlay() {
    _dropOverlayEntry?.remove();
    _dropOverlayEntry = null;
  }

  // ========== 分组 & 渲染 ==========
  List<(String, List<CartItem>)> _groupByShop() {
    final map = <String, List<CartItem>>{};
    for (var item in _mergedItems) {
      map.putIfAbsent(item.shopName, () => []).add(item);
    }
    return map.entries.map((e) => (e.key, e.value)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            const CartHeader(),
            Expanded(child: _buildBody()),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_mergedItems.isEmpty) {
      // 空购物车状态：整页用 CustomScrollView，让「购物车空空如也」随页面一起滚动
      // 同时「猜你喜欢」标题吸顶
      //
      // 空态高度按 5:6 比例分配：
      //   购物车空态 : 猜你喜欢区域 = 5 : 6
      // 通过 LayoutBuilder 获取可用高度，再计算两个区域的高度。
      return LayoutBuilder(
        builder: (context, constraints) {
          final totalHeight = constraints.maxHeight;
          // 5 : 6 总共 11 份
          final emptyHeight = totalHeight * 5 / 11;
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // 上半部分：购物车空态，随页面滚动（不吸顶）
              SliverToBoxAdapter(
                child: SizedBox(
                  height: emptyHeight,
                  child: const CartEmpty(),
                ),
              ),
              // 吸顶：「猜你喜欢」标题
              SliverPersistentHeader(
                pinned: true,
                delegate: _PinnedRecommendHeaderDelegate(),
              ),
              // 商品列表
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                sliver: RecommendSection(
                  items: _recommendItems,
                  hasMore: _hasMoreRecommend,
                  maxCountPerItem: _maxRecommendCount,
                  getCount: _recommendCount,
                  onAddWithPos: _onAddRecommendItem,
                  onMinus: _onMinusRecommendItem,
                  onShowToast: _showToast,
                  showHeader: false,
                ),
              ),
            ],
          );
        },
      );
    }
    final shops = _groupByShop();

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // 店铺卡片
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          sliver: SliverList.separated(
            itemCount: shops.length,
            itemBuilder: (ctx, idx) {
              final (shopName, shopItems) = shops[idx];
              return ShopSection(
                shopName: shopName,
                items: shopItems,
                onToggleSelect: _toggleSelect,
                onQtyChanged: _updateQty,
                onToggleShop: (value) {
                  setState(() {
                    for (var it in shopItems) {
                      it.selected = value;
                    }
                  });
                },
              );
            },
            separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
          ),
        ),
        // 猜你喜欢
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
          sliver: RecommendSection(
            items: _recommendItems,
            hasMore: _hasMoreRecommend,
            maxCountPerItem: _maxRecommendCount,
            getCount: _recommendCount,
            onAddWithPos: _onAddRecommendItem,
            onMinus: _onMinusRecommendItem,
            onShowToast: _showToast,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return CartBottomBar(
      key: _bottomBarKey,
      allSelected: _allSelected,
      totalAmount: _selectedAmount,
      kinds: _selectedKinds,
      count: _selectedCount,
      onToggleAll: _toggleAll,
      onCheckout: _selectedCount == 0
          ? null
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('已勾选 $_selectedCount 件商品，准备结算'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
    );
  }
}

/// 吸顶的「猜你喜欢」标题
///
/// 当用户向上滑动、空态（购物车空空如也）滑出视口后，这一行标题会
/// 固定在滚动区顶部，让用户随时知道下方是推荐商品列表。
class _PinnedRecommendHeaderDelegate extends SliverPersistentHeaderDelegate {
  static const double _headerHeight = 36;

  @override
  double get minExtent => _headerHeight;

  @override
  double get maxExtent => _headerHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: const Color(0xFFF5F5F7),
      height: _headerHeight,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: const Text(
        '猜你喜欢',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF222222),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedRecommendHeaderDelegate oldDelegate) {
    return false;
  }
}
