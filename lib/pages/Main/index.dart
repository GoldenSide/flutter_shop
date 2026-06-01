import 'package:flutter/material.dart';
import 'package:flutter_dianshang/pages/Cart/index.dart';
import 'package:flutter_dianshang/pages/Category/index.dart';
import 'package:flutter_dianshang/pages/Home/index.dart';
import 'package:flutter_dianshang/pages/Mine/index.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 3;

  final List<Map<String, String>> _tabList = [
    {
      'text': '首页',
      'icon': 'lib/assets/ic_public_my_normal.png',
      'selectedIcon': 'lib/assets/ic_public_my_active.png'
    },
    {
      'text': '分类',
      'icon': 'lib/assets/ic_public_pro_normal.png',
      'selectedIcon': 'lib/assets/ic_public_pro_active.png'
    },
    {
      'text': '购物车',
      'icon': 'lib/assets/ic_public_cart_normal.png',
      'selectedIcon': 'lib/assets/ic_public_cart_active.png'
    },
    {
      'text': '我的',
      'icon': 'lib/assets/ic_public_my_normal.png',
      'selectedIcon': 'lib/assets/ic_public_my_active.png'
    }
  ];

  // tabList数据结构
  List<BottomNavigationBarItem> _buildBottomNavItems() {
    return _tabList.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, String> item = entry.value;
      return BottomNavigationBarItem(
        icon: Image.asset(
          _currentIndex == index ? item['selectedIcon']! : item['icon']!,
          width: 24,
          height: 24,
        ),
        label: item['text'],
      );
    }).toList();
  }

  // tabContent具体页面组件
  List<Widget> _buildTabContent() {
    return [
      const HomeView(),
      const CategoryView(),
      const CartView(),
      const MineView()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Main Page'),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _buildTabContent(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _buildBottomNavItems(),
      ),
    );
  }
}

// For convenience: a function to create the route
Route<dynamic> MainPageRoute() {
  return MaterialPageRoute(builder: (_) => const MainPage());
}
