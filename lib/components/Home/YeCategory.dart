import 'package:flutter/material.dart';

class YeCategory extends StatefulWidget {
  const YeCategory({Key? key}) : super(key: key);

  @override
  _YeCategoryState createState() => _YeCategoryState();
}

class _YeCategoryState extends State<YeCategory> {
  final List<Map<String, dynamic>> _categories = [
    {'name': '服装', 'icon': Icons.checkroom},
    {'name': '电子', 'icon': Icons.phone_iphone},
    {'name': '家居', 'icon': Icons.chair},
    {'name': '美妆', 'icon': Icons.brush},
    {'name': '食品', 'icon': Icons.restaurant},
    {'name': '运动', 'icon': Icons.sports_basketball},
    {'name': '母婴', 'icon': Icons.child_friendly},
    {'name': '配件', 'icon': Icons.watch},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: ListView.builder(
        itemCount: _categories.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final item = _categories[index];
          return Container(
              height: 90,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  // 可在此添加分类跳转逻辑
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 100,
                      height: 46,
                      child: Icon(
                        item['icon'] as IconData,
                        size: 28,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['name'] as String,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
