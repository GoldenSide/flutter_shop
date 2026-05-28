
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
	const MainPage({Key? key}) : super(key: key);

	@override
	State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
	int _currentIndex = 0;

	final List<Widget> _pages = [
		const Center(child: Text('首页', style: TextStyle(fontSize: 24))),
		const Center(child: Text('分类', style: TextStyle(fontSize: 24))),
		const Center(child: Text('购物车', style: TextStyle(fontSize: 24))),
		const Center(child: Text('我的', style: TextStyle(fontSize: 24))),
	];

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Main Page'),
				centerTitle: true,
			),
			body: _pages[_currentIndex],
			bottomNavigationBar: BottomNavigationBar(
				currentIndex: _currentIndex,
				type: BottomNavigationBarType.fixed,
				onTap: (index) => setState(() => _currentIndex = index),
				items: const [
					BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
					BottomNavigationBarItem(icon: Icon(Icons.category), label: '分类'),
					BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: '购物车'),
					BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
				],
			),
		);
	}
}

// For convenience: a function to create the route
Route<dynamic> MainPageRoute() {
	return MaterialPageRoute(builder: (_) => const MainPage());
}
