import 'package:flutter/material.dart';
import 'package:flutter_dianshang/pages/Login/index.dart';
import 'package:flutter_dianshang/pages/Main/index.dart';

Widget getRootWidget() {
  return MaterialApp(
    title: 'yejinlong flutter_ohos',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    onGenerateRoute: Routes.generate,
    initialRoute: Routes.home,
  );
}

// 简单路由配置示例
class Routes {
  static const String home = '/';
  static const String details = '/details';
  static const String login = '/login';
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MainPage());
      case details:
        final args = settings.arguments;
        return MaterialPageRoute(builder: (_) => _DetailsPage(data: args));
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('未找到路由')),
            body: const Center(child: Text('404 - Route not found')),
          ),
        );
    }
  }
}

class _DetailsPage extends StatelessWidget {
  final Object? data;

  const _DetailsPage({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(child: Text('接收到: ${data ?? '无数据'}')),
    );
  }
}
