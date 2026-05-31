import 'package:flutter_dianshang/utils/DioRequest.dart';
import 'package:flutter_dianshang/contants/index.dart';
import 'package:flutter_dianshang/viewmodels/home.dart';

// 轮播图数据接口
Future<List<BannerItem>> fetchBannerItems() async {
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
Future<SpecialRecommend> fetchSpecialRecommendItems(
    Map<String, dynamic> params) async {
  try {
    final response =
        await dioRequest.get(HttpConstants.PRODUCT_LIST, params: params);

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

//爆款推荐数据接口
Future<SpecialRecommend> fetchHotRecommendItems() async {
  // final response = await dioRequest.get(HttpConstants.HOT_RECOMMEND_LIST);
  // print('获取爆款推荐数据成功: $response');
  try {
    final response = await dioRequest.get(HttpConstants.IN_VOGUE_LIST);
    // 假设返回的数据结构是 { code: '1', result: [ { id: '...', name: '...', picture: '...', price: '...', stock: '...', sale: '...', comment: '...', goods: [] }, ... ] }
    // final List<dynamic> data = response as List<dynamic>;
    print('获取爆款推荐数据成功: $response');
    return SpecialRecommend.fromJson(response);
  } catch (e) {
    print('获取爆款推荐数据失败: $e');
    // return SpecialRecommend();
    throw e;
  }
}

// 一站买全数据接口
Future<SpecialRecommend> fetchStepRecommendItems() async {
  // final response = await dioRequest.get(HttpConstants.STEP_RECOMMEND_LIST);
  // print('获取一站买全数据成功: $response');
  try {
    final response = await dioRequest.get(HttpConstants.ONE_STOP_LIST);
    // 假设返回的数据结构是 { code: '1', result: [ { id: '...', name: '...', picture: '...', price: '...', stock: '...', sale: '...', comment: '...', goods: [] }, ... ] }
    // final List<dynamic> data = response as List<dynamic>;
    print('获取一站买全数据成功: $response');
    return SpecialRecommend.fromJson(response);
  } catch (e) {
    print('获取一站买全数据失败: $e');
    // return SpecialRecommend();
    throw e;
  }
}

// 推荐列表数据接口
Future<List<GoodsDetailItem>> fetchRecommendList() async {
  // final response = await dioRequest.get(HttpConstants.RECOMMEND_LIST);
  // print('获取推荐列表数据成功: $response');
  try {
    final response = await dioRequest.get(HttpConstants.RECOMMEND_LIST);
    // 假设返回的数据结构是 { code: '1', result: [ { id: '...', name: '...', picture: '...', price: '...', stock: '...', sale: '...', comment: '...', goods: [] }, ... ] }
    final List<dynamic> data = response as List<dynamic>;
    print('获取推荐列表数据成功: $data');
    return data
        .map((item) => GoodsDetailItem.fromJson(item as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('获取推荐列表数据失败: $e');
    return [];
  }
}
