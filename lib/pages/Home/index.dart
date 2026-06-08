import 'package:flutter/material.dart';
import 'package:flutter_dianshang/api/home.dart';
import 'package:flutter_dianshang/components/Home/YeCategory.dart';
import 'package:flutter_dianshang/components/Home/YeHot.dart';
import 'package:flutter_dianshang/components/Home/YeMoreList.dart';
import 'package:flutter_dianshang/components/Home/YeSlider.dart';
import 'package:flutter_dianshang/components/Home/YeSuggestion.dart';
import 'package:flutter_dianshang/utils/ToastUtils.dart';
import 'package:flutter_dianshang/viewmodels/home.dart';

/// 首页
///
/// 负责：数据加载（下拉刷新 + 上拉加载更多）、各模块 Widget 的组合渲染
/// 不负责：UI 细节（交给对应的 Ye* 组件）、具体 API 实现（交给 api/home.dart）
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // ========================= 状态 =========================
  final _controller = ScrollController();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  // 顶部模块
  List<BannerItem> _bannerList = const [];
  List<Category> _categoryList = [];
  SpecialRecommend _specialRecommendList = SpecialRecommend(
    id: '',
    title: '',
    subTypes: [],
  );
  SpecialRecommend _hotRecommendList = SpecialRecommend(
    id: '',
    title: '',
    subTypes: [],
  );
  SpecialRecommend _stepRecommendList = SpecialRecommend(
    id: '',
    title: '',
    subTypes: [],
  );

  // 推荐列表（分页）
  List<GoodsDetailItem> _recommendList = const [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  // 首次进入时的顶部填充（用于把 RefreshIndicator 稍微推下来一点）
  double _paddingTop = 100;

  // 每次加载的 item 数量（每次 +8）
  static const int _pageSize = 8;

  @override
  void initState() {
    super.initState();
    _registerScrollEvent();
    // 延迟一帧触发下拉刷新动画，完成首次数据加载
    Future.microtask(() => _refreshKey.currentState?.show());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ========================= API 封装 =========================
  Future<void> _fetchBannerAndCategoryAndModules() async {
    // 前 5 个接口互相独立，**并行**请求，减少总等待时间
    final results = await Future.wait([
      fetchBannerItems(),
      fetchCategoryItems(),
      fetchSpecialRecommendItems().catchError((_) => SpecialRecommend(id: '', title: '', subTypes: [])),
      fetchHotRecommendItems().catchError((_) => []),
      fetchStepRecommendItems().catchError((_) => []),
    ]);
    
    setState(() {
      _bannerList = results[0] as List<BannerItem>;
      _categoryList = results[1] as List<Category>;
      _specialRecommendList = results[2] as SpecialRecommend;
      _hotRecommendList = results[3] as List<HotItem>;
      _stepRecommendList = results[4] as List<StepItem>;
    });
  }

  /// 分页加载推荐列表
  Future<void> _fetchRecommendList({bool reset = false}) async {
    if (_isLoading) return;

    if (reset) {
      _page = 1;
      _hasMore = true;
      _recommendList = const [];
    }
    if (!_hasMore) return;

    _isLoading = true;
    try {
      final limit = _pageSize * _page;
      final list = await fetchRecommendList({'limit': limit});
      _recommendList = list;
      // 如果返回的数据比请求的 limit 少，说明没有更多了
      _hasMore = list.length >= limit;
      if (_hasMore) _page++;
    } finally {
      _isLoading = false;
      if (mounted) setState(() {});
    }
  }

  // ========================= 事件 =========================
  void _registerScrollEvent() {
    _controller.addListener(() {
      final pos = _controller.position;
      // 距离底部 <= 70 像素时触发加载更多
      if (pos.pixels >= pos.maxScrollExtent - 70) {
        _fetchRecommendList();
      }
    });
  }

  Future<void> _onRefresh() async {
    // 重置分页状态
    _page = 1;
    _isLoading = false;
    _hasMore = true;

    try {
      // 并行加载顶部模块 + 第一页推荐列表
      await Future.wait<void>([
        _fetchBannerAndCategoryAndModules(),
        _fetchRecommendList(reset: true),
      ]);
      if (!mounted) return;
      ToastUtils.showToast(context, '刷新成功');
    } finally {
      // 刷新完成后去掉首次进入时的顶部填充
      _paddingTop = 0;
      if (mounted) setState(() {});
    }
  }

  // ========================= 渲染 =========================
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _onRefresh,
      child: AnimatedContainer(
        padding: EdgeInsets.only(top: _paddingTop),
        duration: const Duration(seconds: 1),
        child: CustomScrollView(
          controller: _controller,
          slivers: _buildSlivers(),
        ),
      ),
    );
  }

  List<Widget> _buildSlivers() {
    return [
      SliverToBoxAdapter(child: YeSlider(bannerList: _bannerList)),
      const _Gap(),
      SliverToBoxAdapter(child: YeCategory(categoryList: _categoryList)),
      const _Gap(),
      SliverToBoxAdapter(
        child: YeSuggestion(specialRecommendList: _specialRecommendList),
      ),
      const _Gap(),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: YeHot(results: _hotRecommendList, type: 'hot')),
              const SizedBox(width: 10),
              Expanded(child: YeHot(results: _stepRecommendList, type: 'step')),
            ],
          ),
        ),
      ),
      const _Gap(),
      YeMoreList(recommendList: _recommendList),
    ];
  }
}

/// 通用的垂直间距，避免到处写 SizedBox(height: 10)
class _Gap extends StatelessWidget {
  const _Gap();

  @override
  Widget build(BuildContext context) =>
      const SliverToBoxAdapter(child: SizedBox(height: 10));
}
