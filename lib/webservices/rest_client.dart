import 'package:dio/dio.dart';

class RestClient {
  static const ENDPOINT = "http://192.168.1.7:8000/api/";
  static Dio _dio;

  static Dio instance(){
    if(_dio == null){
      BaseOptions options = BaseOptions(
        baseUrl: ENDPOINT,
        connectTimeout: 3000,
        receiveTimeout: 3000,
        sendTimeout: 3000
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
  static const RUNDOWN_URL = ENDPOINT+"rundown/";
}