import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rundown_flutter/models/rundown.dart';
import 'package:rundown_flutter/models/rundown_detail.dart';
import 'package:rundown_flutter/webservices/base_list_response.dart';
import 'package:rundown_flutter/webservices/base_response.dart';
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
    }else if(event is FetchSingleRundown){
      yield* _getSingleRundown(event.id);
    }else if (event is FetchCreateRundown){
      yield* _createRundown(event.rundown);
    }else if(event is FetchDeleteRundown){
      yield* _deleteRundown(event.id);
    }else if(event is FetchUpdateRundown){
      yield* _updateRundown(event.rundown);
    }
  }

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('api_token') ?? null);
    return token;
  }

  Stream<RundownState> _deleteRundown(String id) async*{
    try{
      yield RundownLoadingState();
      _dio.options.headers["Authorization"] = "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response res = await _dio.delete(RestClient.RUNDOWN_URL+id+"/");
      BaseResponse baseResponse = BaseResponse.fromJson(res.data);
      if(baseResponse.status){
        yield RundownSuccessState();
      }else{
        yield RundownErrorState(message: "Cannot delete a new rundown");
      }
    }catch(e){
      switch(e.runtimeType){
        case DioError:
          final err = (e as DioError).response;
          print("An error occured with status code "+err.statusCode.toString());
          yield RundownErrorState(message: "Error with code:"+err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield RundownErrorState(message: "Error when requesting to server.");
      }      
    }
  }


Stream<RundownState> _updateRundown(Rundown rundown) async* {
    try{
      yield RundownLoadingState();
      _dio.options.headers["Authorization"] = "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response res = await _dio.put(RestClient.RUNDOWN_URL+rundown.id.toString()+"/", data: {
        "title": rundown.title, "description": rundown.description
      });

      BaseResponse baseResponse = BaseResponse.fromJson(res.data);
      if(baseResponse.status){
        yield RundownSuccessState();
      }else{
        yield RundownErrorState(message: "Cannot update a new rundown");
      }
    }catch(e){
      switch(e.runtimeType){
        case DioError:
          final err = (e as DioError).response;
          print("An error occured with status code "+err.statusCode.toString());
          yield RundownErrorState(message: "Error with code:"+err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield RundownErrorState(message: "Error when requesting to server.");
      }
    }
  }



  Stream<RundownState> _createRundown(Rundown rundown) async* {
    try{
      yield RundownLoadingState();
      _dio.options.headers["Authorization"] = "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response res = await _dio.post(RestClient.RUNDOWN_URL, data: {
        "title": rundown.title, "description": rundown.description
      });

      BaseResponse baseResponse = BaseResponse.fromJson(res.data);
      if(baseResponse.status){
        yield RundownSuccessState();
      }else{
        yield RundownErrorState(message: "Cannot create a new rundown");
      }
    }catch(e){
      switch(e.runtimeType){
        case DioError:
          final err = (e as DioError).response;
          print("An error occured with status code "+err.statusCode.toString());
          yield RundownErrorState(message: "Error with code:"+err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield RundownErrorState(message: "Error when requesting to server.");
      }
    }
  }

  Stream<RundownState> _getSingleRundown(String id) async* {
    try{
      yield RundownLoadingState();
      _dio.options.headers["Authorization"] = "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response response = await _dio.get(RestClient.RUNDOWN_URL+id);
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      if(baseResponse.status){
        Rundown rundown = Rundown.fromJson(baseResponse.data);
        List<RundownDetail> rundownDetails = List();
        for(var rd in rundown.rundownDetails){
          rundownDetails.add(RundownDetail.fromJson(rd));
        }
        rundown.rundownDetails = rundownDetails;
        yield RundownSingleLoadedState(rundown: rundown);
      }else{
        yield RundownErrorState(message: "Sonmething went wrong..");
      }
    }catch(e){
      switch(e.runtimeType){
        case DioError:
          final err = (e as DioError).response;
          print("An error occured with status code "+err.statusCode.toString());
          yield RundownErrorState(message: "Error with code:"+err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield RundownErrorState(message: "Error when requesting to server.");
      }
    }
  }

  Stream<RundownState> _getAllRundown() async* {
    try{
      yield RundownLoadingState();
      // ronaldo 4a6ae9a3e56146e31e59a017403105ed43f34b8f
      _dio.options.headers["Authorization"] = "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response response = await _dio.get(RestClient.RUNDOWN_URL);
      BaseListResponse baseListResponse = BaseListResponse.fromJson(response.data);
      if(baseListResponse.status){
        var data = baseListResponse.data;
        List<Rundown> rundowns = List();
        for(var rundown in data){
          Rundown temp = Rundown.fromJson(rundown);
          if(!temp.isTrashed){ rundowns.add(temp); }
        }
        yield RundownLoadedState(rundowns: rundowns);
      }else{
        yield RundownErrorState(message: baseListResponse.message);
      }
    }catch(exc){
      switch(exc.runtimeType){
        case DioError:
          final err = (exc as DioError).response;
          print("An error occured with status code "+err.statusCode.toString());
          yield RundownErrorState(message: "Error with code:"+err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield RundownErrorState(message: "Error when requesting to server.");
      }
    }
  }
}