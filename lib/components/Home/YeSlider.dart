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
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _getSlider() {
    final double screenWidth = MediaQuery.of(context).size.width;
    return CarouselSlider(
        items: List.generate(widget.bannerList.length, (int index) {
          return Image.network(
            widget.bannerList[index].imgUrl,
            fit: BoxFit.cover,
            width: screenWidth,
          );
        }),
        options: CarouselOptions(viewportFraction: 1, autoPlay: true));
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
        // PageView.builder(
        //   controller: _pageController,
        //   itemCount: widget.bannerList.length,
        //   onPageChanged: (index) {
        //     setState(() {
        //       _currentIndex = index;
        //     });
        //   },
        //   itemBuilder: (context, index) {
        //     return ClipRRect(
        //       borderRadius: BorderRadius.circular(12),
        //       child: Image.network(
        //         widget.bannerList[index].imgUrl,
        //         fit: BoxFit.cover,
        //         width: double.infinity,
        //         loadingBuilder: (context, child, loadingProgress) {
        //           if (loadingProgress == null) return child;
        //           return Center(
        //             child: CircularProgressIndicator(
        //               value: loadingProgress.expectedTotalBytes != null
        //                   ? loadingProgress.cumulativeBytesLoaded /
        //                       loadingProgress.expectedTotalBytes!
        //                   : null,
        //             ),
        //           );
        //         },
        //         errorBuilder: (context, error, stackTrace) {
        //           return Container(
        //             color: Colors.grey[200],
        //             alignment: Alignment.center,
        //             child: const Icon(
        //               Icons.broken_image,
        //               color: Colors.grey,
        //               size: 48,
        //             ),
        //           );
        //         },
        //       ),
        //     );
        //   },
        // ),
        Positioned(
          bottom: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.bannerList.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? Colors.white : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
