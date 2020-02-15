import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rundown_flutter/bloc/search/search_event.dart';
import 'package:rundown_flutter/bloc/search/search_state.dart';
import 'package:rundown_flutter/models/rundown.dart';
import 'package:rundown_flutter/models/search.dart';
import 'package:rundown_flutter/models/user.dart';
import 'package:rundown_flutter/webservices/base_response.dart';
import 'package:rundown_flutter/webservices/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState>{
  Dio _dio = RestClient.instance();
  
  @override
  SearchState get initialState => SearchInitState();

  @override
  Stream<SearchState> mapEventToState(event) async*{
    if(event is FetchSearch){
      yield* _search(event.query);
    }
  }

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('api_token') ?? null);
    return token;
  }


  Stream<SearchState> _search(String query) async* {
    try{
      yield SearchLoadingState();
      _dio.options.headers["Authorization"] = "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response res = await _dio.post(RestClient.SEARCH_URL, data: {
        "query":query
      });
      BaseResponse baseResponse = BaseResponse.fromJson(res.data);
      if(baseResponse.status){
        Search searchResult = Search.fromJson(baseResponse.data);
        List<User> users = List();
        List<Rundown> rundowns = List();
        for(var user in searchResult.users){
          users.add(User.fromJson(user));
          print(User.fromJson(user).name);
          print("uhuy");
        }
        for(var rundown in searchResult.rundowns){
          rundowns.add(Rundown.fromJson(rundown));
        }
        searchResult.users = users;
        searchResult.rundowns = rundowns;
        yield SearchLoadedState(searchResult: searchResult);
      }else{
        yield SearchErrorState(message: "Cannot get search results");
      }
    }catch(e){
      switch(e.runtimeType){
        case DioError:
          final err = (e as DioError).response;
          print("An error occured with status code "+err.statusCode.toString());
          yield SearchErrorState(message: "Error with code:"+err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield SearchErrorState(message: "Error when requesting to server.");
      }
    }
  }
}