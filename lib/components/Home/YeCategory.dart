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
    return Container(
      height: 90,
      child: ListView.builder(
        itemCount: widget.categoryList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = widget.categoryList[index];
          return Container(
              height: 80,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                // color: Theme.of(context).primaryColor.withOpacity(0.1),
                color: Color.fromARGB(255, 231, 233, 234),
                borderRadius: BorderRadius.circular(10),
              ),
              child: GestureDetector(
                onTap: () {
                  // 可在此添加分类跳转逻辑
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 40,
                      child: Image.network(
                        item.picture,
                        width: 28,
                        height: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
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
