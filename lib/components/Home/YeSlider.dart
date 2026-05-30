import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dianshang/api/home.dart';
import 'package:flutter_dianshang/utils/DioRequest.dart';
import 'package:flutter_dianshang/contants/index.dart';
import 'package:flutter_dianshang/viewmodels/home.dart';

class YeSlider extends StatefulWidget {
  // final List<String> imageUrls;
  final double height;
  final List<BannerItem> bannerList;
  // final ValueChanged<int>? onPageChanged;
  const YeSlider({
    Key? key,
    // required this.imageUrls,
    this.height = 260,
    required this.bannerList,
  }) : super(key: key);

  @override
  State<YeSlider> createState() => _YeSliderState();
}

class _YeSliderState extends State<YeSlider> {
  int _currentIndex = 0;
  final CarouselSliderController _sliderController = CarouselSliderController();

  @override
  void dispose() {
    super.dispose();
  }

  Widget _getSlider() {
    final double screenWidth = MediaQuery.of(context).size.width;
    return CarouselSlider(
        carouselController: _sliderController,
        items: List.generate(widget.bannerList.length, (int index) {
          return Image.network(
            widget.bannerList[index].imgUrl,
            fit: BoxFit.cover,
            width: screenWidth,
          );
        }),
        options: CarouselOptions(
          viewportFraction: 1,
          autoPlay: true,
          height: widget.height,
          autoPlayCurve: Easing.standard,
          onPageChanged: (index, reason) => setState(() {
            _currentIndex = index;
          }),
        ));
  }

//搜索组件
  Widget _getSearch() {
    return Positioned(
        top: 20,
        left: 10,
        right: 10,
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          height: 50,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              borderRadius: BorderRadius.circular(25)),
          child: const Text(
            '搜索...',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ));
  }

// 指示灯
  Widget _getDots() {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 8,
        child: Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.bannerList.length, (int index) {
              return GestureDetector(
                onTap: () {
                  _sliderController.jumpToPage(index);
                },
                child: AnimatedContainer(
                  height: 6,
                  width: _currentIndex == index ? 40 : 30,
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? Colors.white
                          : const Color.fromRGBO(0, 0, 0, 0.3),
                      borderRadius: BorderRadius.circular(4)),
                ),
              );
            }),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bannerList.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            '暂无轮播图',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _getSlider(),
        _getSearch(),
        _getDots(),
      ],
    );
  }
}
