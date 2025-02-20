import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:fc_social_fitness/constants/api.dart';
import 'package:sembast/sembast.dart';

import '../utils/app_database.dart';

class HttpService {
  String host = Api.baseUrl;
  BaseOptions? baseOptions;
  Dio? dio;
  DatabaseClient? appDatabase;

  Future<Map<String, String>> getHeaders() async {
    return {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${await getAuthBearerToken()}",
    };
  }

  HttpService() {
    appDatabase = AppDatabase.db;
    baseOptions = BaseOptions(
      baseUrl: host,
      validateStatus: (status) {
        return status! <= 500;
      },
      // connectTimeout: 300,
    );
    final options =  CacheOptions(
      // A default store is required for interceptor.
      store: MemCacheStore(),
      // Default.
      policy: CachePolicy.request,
      // Optional. Returns a cached response on error but for statuses 401 & 403.
      hitCacheOnErrorExcept: [401, 403],
      // Optional. Overrides any HTTP directive to delete entry past this duration.
      maxStale: const Duration(days: 7),
      // Default. Allows 3 cache sets and ease cleanup.
      priority: CachePriority.normal,
      // Default. Body and headers encryption with your own algorithm.
      cipher: null,
      // Default. Key builder to retrieve requests.
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      // Default. Allows to cache POST requests.
      // Overriding [keyBuilder] is strongly recommended.
      allowPostMethod: false,

    );

    dio = Dio(baseOptions)..interceptors.add(DioCacheInterceptor(options: options));
  }

  //Get the access token of the logged in user
  Future<String?> getAuthBearerToken() async {
    final currentUser = await AppDatabase.getCurrentUser();
    return currentUser?.token;
  }

  //for get api calls
  Future<Response?> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        bool includeHeaders = true,
      }) async {
    //preparing the api uri/url
    String uri = "$host$url";
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
      headers: await getHeaders(),
    );
    return dio?.get(
      uri,
      options: mOptions,
      queryParameters: queryParameters,
    );
  }
  //for post api calls
  Future<Response?> put(
      String url,
      body, {
        bool includeHeaders = true,
      }) async {
    //preparing the api uri/url
    String uri = "$host$url";

    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
      headers: await getHeaders(),
    );

    return dio?.put(
      uri,
      data: body,
      options: mOptions,
    );
  }
  //for post api calls
  Future<Response?> post(
      String url,
      body, {
        bool includeHeaders = true,
      }) async {
    //preparing the api uri/url
    String uri = "$host$url";

    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
      headers: await getHeaders(),
    );

    return dio?.post(
      uri,
      data: body,
      options: mOptions,
    );
  }

  //for post api calls with file upload
  Future<Response?> postWithFiles(
      String url,
      body, {
        bool includeHeaders = true,
      }) async {
    //preparing the api uri/url
    String uri = "$host$url";
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
      headers: await getHeaders(),
    );
    Response? response;
    response = await dio?.post(
      uri,
      data: FormData.fromMap(body),
      options: mOptions,
    );
    return response;
  }

  //for patch api calls
  Future<Response?> patch(String url, Map<String, dynamic> body) async {
    String uri = "$host$url";
    return dio?.patch(
      uri,
      data: body,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }

  //for delete api calls
  Future<Response?> delete(
      String url,
      ) async {
    String uri = "$host$url";
    return dio?.delete(
      uri,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }
}