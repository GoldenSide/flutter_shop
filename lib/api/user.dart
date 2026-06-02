import 'package:flutter_dianshang/contants/index.dart';
import 'package:flutter_dianshang/utils/DioRequest.dart';
import 'package:flutter_dianshang/viewmodels/user.dart';

Future<UserInfo> loginApi(Map<String, dynamic> data) async {
  try {
    final response = await dioRequest.post(HttpConstants.LOGIN, data: data);
    print('获取登录数据成功: $response');
    return UserInfo.fromJSON(response);
  } catch (e) {
    print('获取登录数据失败: $e');
    throw e;
  }
}
