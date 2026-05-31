import 'package:flutter/material.dart';
import 'package:flutter_dianshang/viewmodels/home.dart';

class YeMoreList extends StatefulWidget {
  final List<GoodsDetailItem> recommendList;
  const YeMoreList({super.key, this.recommendList = const []});

  @override
  State<YeMoreList> createState() => _YeMoreListState();
}

class _YeMoreListState extends State<YeMoreList> {
  final ScrollController _scrollController = ScrollController();
  final List<int> _items = List.generate(20, (index) => index);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildItem(int index) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  widget.recommendList[index].picture,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('lib/assets/home_cmd_inner.png');
                  },
                ),
              )),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              widget.recommendList[index].name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: const TextStyle(
                color: Color.fromARGB(197, 31, 4, 4),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                      text: '¥${widget.recommendList[index].price}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(text: '  '),
                        TextSpan(
                          text: '¥${widget.recommendList[index].price}',
                          style: const TextStyle(
                            color: Color.fromARGB(106, 12, 4, 4),
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ]),
                ),
                Text(
                  '${widget.recommendList[index].payCount}人已付款',
                  style: const TextStyle(
                    color: Color.fromARGB(106, 12, 4, 4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverGrid.builder(
        itemCount: widget.recommendList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.725,
        ),
        itemBuilder: (context, index) {
          return _buildItem(index);
        },
      ),
    );
  }
}
