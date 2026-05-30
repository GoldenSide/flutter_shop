import 'package:dio/dio.dart';
import '../contants/index.dart';

class DioRequest {
  static final DioRequest _instance = DioRequest._internal();
  factory DioRequest() => _instance;

  late final Dio _dio;

  DioRequest._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: GlobalConstants.BASE_URL,
      connectTimeout: const Duration(seconds: GlobalConstants.TIME_OUT),
      receiveTimeout: const Duration(seconds: GlobalConstants.TIME_OUT),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    _dio = Dio(options);
    _addInterceptors();
  }
  void _addInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 在请求发送之前可以进行一些处理，例如添加公共参数、设置请求头等
        // options.headers['Authorization'] = 'Bearer your_token';
        return handler.next(options); // 继续发送请求
      },
      onResponse: (response, handler) {
        // 在接收到响应之后可以进行一些处理，例如统一处理错误码、解析数据等
        if (response.statusCode == 200) {
          // 成功响应
          return handler.next(response); // 继续处理响应
        } else {
          // 错误响应
          return handler.reject(DioError(
            requestOptions: response.requestOptions,
            response: response,
            type: DioErrorType.badResponse,
            error: '请求失败，状态码：${response.statusCode}',
          ));
        }
      },
      onError: (error, handler) {
        // 在请求发生错误时可以进行一些处理，例如统一处理网络错误、超时等
        return handler.next(error); // 继续处理错误
      },
    ));
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _handleResponse(_dio.get(
      path,
      queryParameters: params,
      options: options,
      cancelToken: cancelToken,
    ));
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _handleResponse(_dio.post(
      path,
      data: data,
      options: options,
      cancelToken: cancelToken,
    ));
  }

  Future<dynamic> _handleResponse(Future<Response> task) async {
    Response<dynamic> response = await task;
    final data = response.data as Map<String, dynamic>;
    try {
      if (data['code'] != GlobalConstants.SUCCESS_CODE) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: '请求失败，错误码：${data['code']}，错误信息：${data['message']}',
        );
      } else {
        return data['result'];
      }
    } catch (e) {
      rethrow;
    }
  }
}

// 单列对象
final dioRequest = DioRequest();
