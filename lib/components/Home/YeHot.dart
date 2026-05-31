import 'package:flutter/material.dart';
import 'package:flutter_dianshang/viewmodels/home.dart';

class YeHot extends StatelessWidget {
  final SpecialRecommend results;
  final String type;
  const YeHot({Key? key, required this.results, required this.type})
      : super(key: key);

  String get title => type == 'hot' ? '爆款推荐' : '一站买全';
  String get subTitle => type == 'hot' ? '最受欢迎' : '精心优选';
  Color get bgColor => type == 'hot'
      ? const Color.fromARGB(255, 211, 228, 240)
      : const Color.fromARGB(255, 249, 247, 219);
  List<GoodsItem> get itemList {
    if (results.subTypes.isEmpty) {
      return [];
    }
    return results.subTypes.first.goodsItems.items.take(2).toList();
  }

  // 头部结构
  Widget _getTopContentWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          subTitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // 底部结构
  Widget _getBottomContentWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: itemList
          .map((item) => Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.network(
                    item.picture,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '￥${item.price.toString()}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 134, 63, 50),
                    ),
                  ),
                ],
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      // height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getTopContentWidget(),
          const SizedBox(height: 12),
          _getBottomContentWidget(),
        ],
      ),
    );
  }
}
