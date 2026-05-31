import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dianshang/api/home.dart';
import 'package:flutter_dianshang/components/Home/YeCategory.dart';
import 'package:flutter_dianshang/components/Home/YeHot.dart';
import 'package:flutter_dianshang/components/Home/YeMoreList.dart';
import 'package:flutter_dianshang/components/Home/YeSlider.dart';
import 'package:flutter_dianshang/components/Home/YeSuggestion.dart';
import 'package:flutter_dianshang/viewmodels/home.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _controller = ScrollController();

  // int _page = 1;
  // bool _isLoading = false;
  // bool _hasMore = true;
  List<BannerItem> _bannerList = [];
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
  List<GoodsDetailItem> _recommendList = [];

  @override
  void initState() {
    super.initState();
    // 加载所有异步请求数据
    _getSyncData();
  }

  // 轮播图
  Future<void> _getBannerList() async {
    _bannerList = await fetchBannerItems();
    setState(() {});
  }

// 分类
  Future<void> _getCategoryList() async {
    _categoryList = await fetchCategoryItems();
    setState(() {});
  }

  // 特惠推荐
  Future<void> _getSpecialRecommendList() async {
    _specialRecommendList = await fetchSpecialRecommendItems({"limit": 10});
    print('yejinllong==特惠推荐: $_specialRecommendList');
    setState(() {});
  }

// 爆款推荐
  Future<void> _getHotRecommendList() async {
    _hotRecommendList = await fetchHotRecommendItems();
    print('yejinllong==爆款推荐: $_hotRecommendList');
    setState(() {});
  }

  // 一站买全
  Future<void> _getStepRecommendList() async {
    _stepRecommendList = await fetchStepRecommendItems();
    print('yejinllong==一站买全: $_stepRecommendList');
    setState(() {});
  }

// 推荐列表
  Future<void> _getRecommendList() async {
    _recommendList = await fetchRecommendList();
    print('yejinllong==推荐列表: $_recommendList');
    setState(() {});
  }

  void _getSyncData() {
    _getBannerList();
    _getCategoryList();
    _getSpecialRecommendList();
    _getHotRecommendList();
    _getStepRecommendList();
    _getRecommendList();
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

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      slivers: _getScrollChildren(),
    );
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
