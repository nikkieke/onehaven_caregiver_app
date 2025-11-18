import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkServiceProvider = Provider((ref) => NetworkService());

class NetworkService {
  late final Dio _dio;

  NetworkService._internal({Dio? dioOverrides}) {
    dioOverrides ?? Dio(baseOption);
  }

  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() => _instance;

  BaseOptions get baseOption => BaseOptions();

  String get baseUrl => 'http://localhost:8080';

  Map<String, String> get headers => {
    'accept': 'application/json',
    'content-type': 'application/json',
  };

  Future<Response<dynamic>> request({
    required String path,
    bool enableCache = true,
    dynamic data,
    required RequestMethod method,
  }) async {
    Response<dynamic> response;

    try {
      switch (method) {
        case RequestMethod.get:
          response = await _dio.get(path);
        case RequestMethod.put:
          response = await _dio.put(path, data: data);
      }
      return response;
    } on DioException catch (e) {
      throw '${e.message}';
    }
  }
}

enum RequestMethod { get, put }
