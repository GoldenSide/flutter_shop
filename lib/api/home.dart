import 'package:flutter_dianshang/utils/DioRequest.dart';
import 'package:flutter_dianshang/contants/index.dart';
import 'package:flutter_dianshang/viewmodels/home.dart';

Future<List<BannerItem>> fetchBannerItems() async {
  // final response = await dioRequest.get(HttpConstants.BANNER_LIST);
  // print('获取轮播图数据成功: $response');
  try {
    final response = await dioRequest.get(HttpConstants.BANNER_LIST);
    // 假设返回的数据结构是 { code: '1', result: [ { imageUrl: '...', id: '...' }, ... ] }
    final List<dynamic> data = response as List<dynamic>;
    print('获取轮播图数据成功: $data');
    return data
        .map((item) => BannerItem.formJSON(item as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('获取轮播图数据失败: $e');
    return [];
  }
}
