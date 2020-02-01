import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rundown_flutter/models/rundown.dart';
import 'package:rundown_flutter/webservices/base_list_response.dart';
import 'package:rundown_flutter/webservices/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'rundown_event.dart';
import 'rundown_state.dart';

class RundownBloc extends Bloc<RundownEvent, RundownState>{
  Dio _dio = RestClient.instance();

  @override
  RundownState get initialState => RundownInitState();

  @override
  Stream<RundownState> mapEventToState(RundownEvent event) async* {
    if(event is FetchRundown){
      yield* _getAllRundown();
    } 
  }

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('api_token') ?? null);
    return token;
  }

  Stream<RundownState> _getAllRundown() async* {
    try{
      yield RundownLoadingState();
      _dio.options.headers["Authorization"] = "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response response = await _dio.get(RestClient.RUNDOWN_URL);
      BaseListResponse baseListResponse = BaseListResponse.fromJson(response.data);
      if(baseListResponse.status){
        var data = baseListResponse.data;
        List<Rundown> rundowns = List();
        for(var rundown in data){
          Rundown temp = Rundown.fromJson(rundown);
          if(!temp.isTrashed){
            rundowns.add(temp);
          }
        }
        yield RundownLoadedState(rundowns: rundowns);
      }else{
        yield RundownErrorState(message: baseListResponse.message);
      }
    }catch(exc){
      switch(exc.runtimeType){
        case DioError:
          final err = (exc as DioError).response;
          yield RundownErrorState(message: "Error with code:"+err.statusCode.toString());
          break;
        default:
          print("anu x");
          yield RundownErrorState(message: "Error when requesting to server.");
      }
    }
  }
}