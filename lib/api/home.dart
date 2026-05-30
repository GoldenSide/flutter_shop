import 'package:flutter_dianshang/utils/DioRequest.dart';
import 'package:flutter_dianshang/contants/index.dart';
import 'package:flutter_dianshang/viewmodels/home.dart';

// 轮播图数据接口
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

// 分类数据接口
Future<List<Category>> fetchCategoryItems() async {
  // final response = await dioRequest.get(HttpConstants.CATEGORY_LIST);
  // print('获取分类数据成功: $response');
  try {
    final response = await dioRequest.get(HttpConstants.CATEGORY_LIST);
    // 假设返回的数据结构是 { code: '1', result: [ { id: '...', name: '...', picture: '...', children: [], goods: [] }, ... ] }
    final List<dynamic> data = response as List<dynamic>;
    print('获取分类数据成功: $data');
    return data
        .map((item) => Category.fromJson(item as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('获取分类数据失败: $e');
    return [];
  }
}

// 特惠推荐数据接口
Future<SpecialRecommend> fetchRecommendItems() async {
  // final response = await dioRequest.get(HttpConstants.PRODUCT_LIST);
  // print('获取特惠推荐数据成功: $response');
  try {
    final response = await dioRequest.get(HttpConstants.PRODUCT_LIST);
    // 假设返回的数据结构是 { code: '1', result: [ { id: '...', name: '...', picture: '...', price: '...', stock: '...', sale: '...', comment: '...', goods: [] }, ... ] }
    // final List<dynamic> data = response as List<dynamic>;
    print('获取特惠推荐数据成功: $response');
    return SpecialRecommend.fromJson(response);
  } catch (e) {
    print('获取特惠推荐数据失败: $e');
    // return SpecialRecommend();
    throw e;
  }
}
