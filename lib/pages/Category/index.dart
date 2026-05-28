import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({Key? key}) : super(key: key);

  final List<String> categories = const [
    '推荐',
    '女装',
    '男装',
    '鞋包',
    '美妆',
    '家居',
    '数码',
    '母婴',
    '美食',
    '运动',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分类'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: categories.length,
        separatorBuilder: (context, index) {
          return const Divider(height: 1);
        },
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('点击了 $category')),
              );
            },
          );
        },
      ),
    );
  }
}
