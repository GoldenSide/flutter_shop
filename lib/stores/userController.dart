import 'package:flutter_dianshang/viewmodels/user.dart';
import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// 对象里面需要有共享的对象 而且需要响应式更新
class UserController extends GetxController {
  // 用户信息
  var userInfo = UserInfo.fromJSON({}).obs;

  // 更新用户信息的方法
  void updateUserInfo(UserInfo newInfo) {
    userInfo.value = newInfo;
  }
}
