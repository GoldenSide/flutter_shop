import 'package:flutter/material.dart';
import 'package:flutter_dianshang/api/mine.dart';
import 'package:flutter_dianshang/components/Home/YeMoreList.dart';
import 'package:flutter_dianshang/components/Mine/YeGuess.dart';
import 'package:flutter_dianshang/viewmodels/home.dart';
import 'package:flutter_dianshang/viewmodels/mine.dart';

class MineView extends StatefulWidget {
  const MineView({Key? key}) : super(key: key);

  @override
  State<MineView> createState() => _MineViewState();
}

// ignore: unused_element

class _MineViewState extends State<MineView> {
  List<GoodsDetailItem> _guessList = [];
  Map<String, dynamic> params = {
    "pageSize": 10,
    "page": 1,
  };
  bool _isLoading = false;
  bool _hasMore = true;
  void _getGuessList() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    final GuessGoodsItems data = await fetchGuessList(params);
    _guessList.addAll(data.items);
    _isLoading = false;
    _hasMore = params['page'] < data.pages;
    if (_hasMore) {
      params['page']++;
    }
    print('猜你喜欢数据: $_guessList');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // 先注册事件,再执行微任务加载数据
    _registerEvent();
    _getGuessList();
  }

  final ScrollController _controller = ScrollController();

  void _registerEvent() {
    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 70) {
        // 到达底部
        print(
            '到达底部${_controller.position.pixels} ,${_controller.position.maxScrollExtent}');
        // 加载更多数据
        _getGuessList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverToBoxAdapter(
          child: _buildUserInfo(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
        // SliverToBoxAdapter(
        //   child: _buildMenuItems(),
        // ),
        // const SliverToBoxAdapter(
        //   child: SizedBox(height: 16),
        // ),
        SliverToBoxAdapter(
          child: _buildVipContent(),
        ),
        SliverToBoxAdapter(
          child: _buildQuickAction(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
        SliverPersistentHeader(
          delegate: YeGuess(),
          pinned: true,
        ),
        YeMoreList(
          recommendList: _guessList,
        ),
      ],
    );
  }

// 用户信息 登录状态
  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Image.asset('lib/assets/goods_avatar.png'),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '立即登录',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

// 会员信息 收藏等
  Widget _buildVipContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 239, 197, 153),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              'lib/assets/ic_user_vip.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                '升级美荟商城会员，尊享无限免邮',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(128, 44, 26, 1),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                backgroundColor: const Color.fromRGBO(126, 43, 26, 1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('立即开通'),
            )
          ],
        ),
      ),
    );
  }

// 快连接
  Widget _buildQuickAction() {
    Widget _buildQuickActionItem(String icon, String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Image.asset(
                icon as String,
                width: 24,
                height: 24,
              ),
              const SizedBox(height: 4),
              Text(title, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickActionItem('lib/assets/ic_user_collect.png', '我的收藏'),
            _buildQuickActionItem('lib/assets/ic_user_history.png', '我的足迹'),
            _buildQuickActionItem('lib/assets/ic_user_service.png', '我的客服'),
          ],
        ),
      ),
    );
  }
}
