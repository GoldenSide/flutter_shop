import 'package:flutter/material.dart';
import 'package:flutter_dianshang/viewmodels/home.dart';

class YeCategory extends StatefulWidget {
  final List<Category> categoryList;
  const YeCategory({Key? key, required this.categoryList}) : super(key: key);

  @override
  _YeCategoryState createState() => _YeCategoryState();
}

class _YeCategoryState extends State<YeCategory> {
  @override
  Widget build(BuildContext context) {
    if (widget.categoryList.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        itemCount: widget.categoryList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = widget.categoryList[index];
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('进入「${item.name}」'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              width: 72,
              margin: EdgeInsets.only(
                left: index == 0 ? 12 : 8,
                right: index == widget.categoryList.length - 1 ? 12 : 0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F3F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.network(
                      item.picture,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.category, color: Colors.grey);
                      },
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
