import 'package:dio/dio.dart';

class RestClient {
  static const ENDPOINT = "localhots:8000/api/";
  static Dio _dio;

  static Dio instance(){
    if(_dio == null){
      BaseOptions options = BaseOptions(
        baseUrl: ENDPOINT,
        connectTimeout: 30000,
        receiveTimeout: 30000,
        sendTimeout: 30000
      );
      _dio = Dio(options);
      return _dio;
    }
    return _dio;
  }

  static const LOGIN_URL = ENDPOINT+"login/";
  static const REGISTER_URL = ENDPOINT+"register/";
  static const USER_URL = ENDPOINT+"user/";
  static const FRIEND_URL = ENDPOINT+"friend/";
  static const RUNDOWN_DETAIL_URL = ENDPOINT+"rundown_detail/";
}