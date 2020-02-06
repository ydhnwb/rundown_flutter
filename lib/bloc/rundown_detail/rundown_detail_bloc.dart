import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rundown_flutter/bloc/rundown_detail/rundown_detail_event.dart';
import 'package:rundown_flutter/bloc/rundown_detail/rundown_detail_state.dart';
import 'package:rundown_flutter/models/rundown_detail.dart';
import 'package:rundown_flutter/webservices/base_response.dart';
import 'package:rundown_flutter/webservices/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RundownDetailBloc extends Bloc<RundownDetailEvent, RundownDetailState> {
  Dio _dio = RestClient.instance();

  @override
  RundownDetailState get initialState => RundownDetailInitState();

  @override
  Stream<RundownDetailState> mapEventToState(RundownDetailEvent event) async* {
    if (event is FetchCreateRundownDetail) {
      yield* _createRundownDetail(event.rundownDetail);
    } else if (event is FetchUpdateRundownDetail) {
      yield* _updateRundownDetail(event.rundownDetail);
    } else if (event is FetchDeleteRundownDetail) {
      yield* _deleteRundownDetail(event.id);
    } else if (event is FetchSingleRundownDetail) {
      yield* _getSingleRundownDetail(event.id);
    }
  }

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('api_token') ?? null);
    return token;
  }

  Stream<RundownDetailState> _deleteRundownDetail(String id) async* {
    try {
      yield RundownDetailLoadingState();
      _dio.options.headers["Authorization"] =
          "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response res =
          await _dio.delete(RestClient.RUNDOWN_DETAIL_URL + id + "/");
      BaseResponse baseResponse = BaseResponse.fromJson(res.data);
      if (baseResponse.status) {
        yield RundownDetailSuccessState();
      } else {
        yield RundownDetailErrorState(message: "Cannot delete a new rundown");
      }
    } catch (e) {
      switch (e.runtimeType) {
        case DioError:
          final err = (e as DioError).response;
          print(
              "An error occured with status code " + err.statusCode.toString());
          yield RundownDetailErrorState(
              message: "Error with code:" + err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield RundownDetailErrorState(
              message: "Error when requesting to server.");
      }
    }
  }

  Stream<RundownDetailState> _createRundownDetail(RundownDetail rundownDetail) async* {
    try {
      yield RundownDetailLoadingState();
      _dio.options.headers["Authorization"] =
          "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response response = await _dio.post(RestClient.RUNDOWN_DETAIL_URL, data: {
        "title": rundownDetail.title,
        "description": rundownDetail.description,
        "rundown": rundownDetail.rundownId
      });
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.status) {
        yield RundownDetailSuccessState();
      } else {
        yield RundownDetailErrorState(message: "Cannot create a new rundown");
      }
    } catch (e) {
      switch (e.runtimeType) {
        case DioError:
          final err = (e as DioError).response;
          print(
              "An error occured with status code " + err.statusCode.toString());
          yield RundownDetailErrorState(
              message: "Error with code:" + err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield RundownDetailErrorState(
              message: "Error when requesting to server.");
      }
    }
  }

  Stream<RundownDetailState> _updateRundownDetail(RundownDetail rundownDetail) async* {
    try {
      yield RundownDetailLoadingState();
      _dio.options.headers["Authorization"] =
          "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response response = await _dio.patch(
          RestClient.RUNDOWN_DETAIL_URL + rundownDetail.id.toString() + "/",
          data: {
            "title": rundownDetail.title,
            "description": rundownDetail.description,
            "rundown": rundownDetail.rundownId
          });
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.status) {
        yield RundownDetailSuccessState();
      } else {
        yield RundownDetailErrorState(message: "Cannot create a new rundown");
      }
    } catch (e) {
      switch (e.runtimeType) {
        case DioError:
          final err = (e as DioError).response;
          print(
              "An error occured with status code " + err.statusCode.toString());
          yield RundownDetailErrorState(
              message: "Error with code:" + err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield RundownDetailErrorState(
              message: "Error when requesting to server.");
      }
    }
  }

  Stream<RundownDetailState> _getSingleRundownDetail(String id) async* {
    try {
      yield RundownDetailLoadingState();
      _dio.options.headers["Authorization"] =
          "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response response = await _dio.get(RestClient.RUNDOWN_DETAIL_URL + id);
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.status) {
        RundownDetail rundownDetail = RundownDetail.fromJson(baseResponse.data);
        yield RundownDetailSingleLoadedState(rundownDetail: rundownDetail);
      } else {
        yield RundownDetailErrorState(message: "Sonmething went wrong..");
      }
    } catch (e) {
      switch (e.runtimeType) {
        case DioError:
          final err = (e as DioError).response;
          print(
              "An error occured with status code " + err.statusCode.toString());
          yield RundownDetailErrorState(
              message: "Error with code:" + err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield RundownDetailErrorState(
              message: "Error when requesting to server.");
      }
    }
  }
}
