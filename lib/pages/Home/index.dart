import 'package:flutter/material.dart';
import 'package:flutter_dianshang/components/Home/YeCategory.dart';
import 'package:flutter_dianshang/components/Home/YeHot.dart';
import 'package:flutter_dianshang/components/Home/YeMoreList.dart';
import 'package:flutter_dianshang/components/Home/YeSlider.dart';
import 'package:flutter_dianshang/components/Home/YeSuggestion.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            // padding: const EdgeInsets.all(16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Text(
                //   '欢迎来到Flutter电商',
                //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 16),
                YeSlider(
                  imageUrls: [
                    'https://img.yzcdn.cn/vant/cat.jpeg',
                    'https://img.yzcdn.cn/vant/cat.jpeg',
                    'https://img.yzcdn.cn/vant/cat.jpeg',
                  ],
                ),
              ],
            ),
          ),
        ),
        // 其他内容可以继续添加Sliver组件
        const SliverToBoxAdapter(
          child: SizedBox(height: 10),
        ),
        const SliverToBoxAdapter(
          child: YeCategory(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 10),
        ),
        const SliverToBoxAdapter(
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
      ],
    );
  }
}
