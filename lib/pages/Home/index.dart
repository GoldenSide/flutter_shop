import 'package:flutter/material.dart';
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

  void _getSyncData() {
    _getBannerList();
    _getCategoryList();
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
          suggestions: [
            '推荐商品1',
            '推荐商品2',
            '推荐商品3',
          ],
        ),
      ),
      const SliverToBoxAdapter(
        child: SizedBox(height: 10),
      ),
      const SliverToBoxAdapter(
        child: YeHot(),
      ),
      const SliverToBoxAdapter(
        child: SizedBox(height: 10),
      ),
      YeMoreList(),
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
