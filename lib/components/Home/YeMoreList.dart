import 'package:flutter/material.dart';

class YeMoreList extends StatefulWidget {
  const YeMoreList({Key? key}) : super(key: key);

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
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    final int currentLength = _items.length;
    _items.addAll(List.generate(20, (index) => currentLength + index));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Item ${_items[index]}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          },
          childCount: _items.length,
        ),
      ),
    );
  }
}


//  SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             child: Center(
//               child: _isLoading
//                   ? const CircularProgressIndicator()
//                   : const SizedBox.shrink(),
//             ),
//           ),
//         ),