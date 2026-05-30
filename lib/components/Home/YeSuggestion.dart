import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_dianshang/viewmodels/home.dart';

class YeSuggestion extends StatelessWidget {
  final SpecialRecommend recommendList;
  final void Function(String)? onTap;

  const YeSuggestion({
    Key? key,
    required this.recommendList,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recommendList.subTypes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: const Text(
          '暂无推荐',
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      );
    }

// 顶部内容

    Widget _buildTopContent() {
      return const Row(
        children: [
          Text(
            '特惠推荐',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Text(
            '精选省攻略',
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(96, 0, 0, 0),
            ),
          ),
        ],
      );
    }

// 底部左侧
    Widget _buildBottomLeft() {
      return Image.asset(
        'lib/assets/home_cmd_inner.png',
        width: 100,
        height: 140,
        fit: BoxFit.cover,
      );
    }

// 底部右侧
    List<Widget> _buildBottomRight() {
      if (recommendList.subTypes.isEmpty) {
        return [];
      }
      List<GoodsItem> goodsItems =
          recommendList.subTypes[0].goodsItems.items.take(3).toList();
      return List.generate(goodsItems.length, (index) {
        return Column(children: [
          Image.network(
            goodsItems[index].picture,
            width: 100,
            height: 160,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('lib/assets/home_cmd_inner.png');
            },
          ),
          const SizedBox(height: 5),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromARGB(191, 244, 67, 54),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(6),
            height: 30,
            width: 80,
            child: Text(
              '¥' + goodsItems[index].price,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ]);
      });
    }

//
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: double.infinity,
          // height: 300,
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: AssetImage('lib/assets/home_cmd_sm.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              _buildTopContent(),
              const SizedBox(height: 10),
              Row(children: [
                _buildBottomLeft(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _buildBottomRight(),
                  ),
                ),
              ]),
            ],
          ),
        ));
  }
}
