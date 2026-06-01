// 推荐列表数据接口

import 'package:flutter_dianshang/contants/index.dart';
import 'package:flutter_dianshang/utils/DioRequest.dart';
import 'package:flutter_dianshang/viewmodels/mine.dart';

Future<GuessGoodsItems> fetchGuessList(Map<String, dynamic> params) async {
  try {
    final response =
        await dioRequest.get(HttpConstants.GUESS_LIST, params: params);
    final GuessGoodsItems data = GuessGoodsItems.fromJson(response);
    print('获取猜你喜欢数据成功: $data');
    return data;
  } catch (e) {
    print('获取猜你喜欢数据失败: $e');
    throw e;
  }
}
