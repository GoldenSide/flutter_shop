import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dianshang/api/home.dart';
import 'package:flutter_dianshang/components/Home/YeCategory.dart';
import 'package:flutter_dianshang/components/Home/YeHot.dart';
import 'package:flutter_dianshang/components/Home/YeMoreList.dart';
import 'package:flutter_dianshang/components/Home/YeSlider.dart';
import 'package:flutter_dianshang/components/Home/YeSuggestion.dart';
import 'package:flutter_dianshang/utils/ToastUtils.dart';
import 'package:flutter_dianshang/viewmodels/home.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _controller = ScrollController();

  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  List<BannerItem> _bannerList = [];
  List<Category> _categoryList = [];
  double paddingTop = 100;

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
  List<GoodsDetailItem> _recommendList = [];

  @override
  void initState() {
    super.initState();
    // 先注册事件,再执行微任务加载数据
    _registerEvent();
    // 加载所有异步请求数据
    // initState->build->下拉刷新组件->才可以操作
    Future.microtask(() => _globalKey.currentState?.show());
  }

  // 轮播图
  Future<void> _getBannerList() async {
    _bannerList = await fetchBannerItems();
  }

// 分类
  Future<void> _getCategoryList() async {
    _categoryList = await fetchCategoryItems();
  }

  // 特惠推荐
  Future<void> _getSpecialRecommendList() async {
    _specialRecommendList = await fetchSpecialRecommendItems();
    print('yejinllong==特惠推荐: $_specialRecommendList');
  }

// 爆款推荐
  Future<void> _getHotRecommendList() async {
    _hotRecommendList = await fetchHotRecommendItems();
    print('yejinllong==爆款推荐: $_hotRecommendList');
  }

  // 一站买全
  Future<void> _getStepRecommendList() async {
    _stepRecommendList = await fetchStepRecommendItems();
    print('yejinllong==一站买全: $_stepRecommendList');
    ;
  }

// 推荐列表
  Future<void> _getRecommendList() async {
    if (_isLoading || !_hasMore) {
      return;
    }
    int limit = 8 * _page;
    _isLoading = true;
    _recommendList = await fetchRecommendList({"limit": limit});
    _isLoading = false;
    _hasMore = _recommendList.length >= limit;
    if (_hasMore) {
      _page++;
    }
    print('yejinllong==推荐列表: $_recommendList');
  }

  // 添加滚动事件
  void _registerEvent() {
    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 60) {
        // 到达底部
        print('到达底部');
        // 加载更多数据
        _getRecommendList();
        setState(() {});
      }
    });
  }

  Future<void> _getSyncData() async {
    await _getBannerList();
    await _getCategoryList();
    await _getSpecialRecommendList();
    await _getHotRecommendList();
    await _getStepRecommendList();
    await _getRecommendList();
  }

  List<Widget> _getScrollChildren() {
    return [
      SliverToBoxAdapter(
        // padding: const EdgeInsets.all(16),
        child: YeSlider(
          bannerList: _bannerList,
        ),
      ),
      const SliverToBoxAdapter(
        child: SizedBox(height: 10),
      ),
      SliverToBoxAdapter(
        child: YeCategory(categoryList: _categoryList),
      ),
      const SliverToBoxAdapter(
        child: SizedBox(height: 10),
      ),
      SliverToBoxAdapter(
        child: YeSuggestion(
          specialRecommendList: _specialRecommendList,
        ),
      ),
      const SliverToBoxAdapter(
        child: SizedBox(height: 10),
      ),
      SliverToBoxAdapter(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: YeHot(
                results: _hotRecommendList,
                type: 'hot',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: YeHot(
                results: _stepRecommendList,
                type: 'step',
              ),
            ),
          ],
        ),
      )),
      const SliverToBoxAdapter(
        child: SizedBox(height: 10),
      ),
      YeMoreList(
        recommendList: _recommendList,
      ),
    ];
  }

// 下拉刷新
  Future<void> _onRefresh() async {
    _page = 1;
    _isLoading = false;
    _hasMore = true;
    await _getSyncData();
    ToastUtils.showToast(context, '刷新成功');
    paddingTop = 0;
    setState(() {});
  }

// GlobalKey 是一个方法可以创建一个key绑定到Widget 上 可以操作该Widget 的状态
  final GlobalKey<RefreshIndicatorState> _globalKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        key: _globalKey,
        onRefresh: _onRefresh,
        child: AnimatedContainer(
          padding: EdgeInsets.only(top: paddingTop),
          duration: const Duration(seconds: 1),
          child: CustomScrollView(
            controller: _controller,
            slivers: _getScrollChildren(),
          ),
        ));
  }
}

class demo extends StatefulWidget {
  final List<BannerItem> bannerList;
  const demo({super.key, required this.bannerList});

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.bannerList[0].imgUrl,
      width: 300,
      height: 300,
    );
  }
}
