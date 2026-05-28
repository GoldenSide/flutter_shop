import 'package:flutter/material.dart';

class YeHot extends StatelessWidget {
  const YeHot({Key? key}) : super(key: key);

  final List<String> _hotItems = const [
    '热卖商品1',
    '热卖商品2',
    '热卖商品3',
    '热卖商品4',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '热门推荐',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.local_fire_department, color: Colors.red),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _hotItems.map((item) {
              return Chip(
                label: Text(item),
                backgroundColor: Colors.orange.shade50,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
