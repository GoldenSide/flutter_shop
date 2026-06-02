import 'package:flutter_dianshang/contants/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String tokenKey = GlobalConstants.TOKEN_KEY; // 存储 token 的键
  String? _token = ''; // 内存中的 token

  _getInstance() async {
    // 获取 SharedPreferences 实例
    return await SharedPreferences.getInstance();
  }

  init() async {
    // 初始化 SharedPreferences 实例
    final prefs = await _getInstance();
    _token = prefs.getString(tokenKey); // 从 SharedPreferences 中获取 token
  }

  setToken(String token) async {
    final prefs = await _getInstance();
    await prefs.setString(tokenKey, token); // 存储 token
    _token = token; // 更新内存中的 token
  }

  getToken() {
    return _token; // 获取 token
  }

  removeToken() async {
    final prefs = await _getInstance();
    await prefs.remove(tokenKey); // 删除 token
    _token = ''; // 清除内存中的 token
  }
}

final tokenManager = TokenManager();
