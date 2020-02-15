import 'package:dio/dio.dart';

class RestClient {
  static const ENDPOINT = "http://192.168.1.7:8000/api/";
  static Dio _dio;

  static Dio instance(){
    if(_dio == null){
      _dio = Dio()
      ..options.baseUrl = ENDPOINT
      ..options.connectTimeout = 30000
      ..options.receiveTimeout = 30000
      ..options.sendTimeout = 30000;
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
  static const SEARCH_URL = ENDPOINT+"search/";
}