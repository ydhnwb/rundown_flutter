import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rundown_flutter/bloc/friend/friend_event.dart';
import 'package:rundown_flutter/bloc/friend/friend_state.dart';
import 'package:rundown_flutter/models/friend.dart';
import 'package:rundown_flutter/webservices/base_list_response.dart';
import 'package:rundown_flutter/webservices/base_response.dart';
import 'package:rundown_flutter/webservices/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState>{
  Dio _dio = RestClient.instance();

  @override
  FriendState get initialState => FriendInitState();

  @override
  Stream<FriendState> mapEventToState(FriendEvent event) async* {
    if(event is Unfriend){
      yield* _unfriend(event.id);
    }else if (event is SendFriendRequest){
      yield* _makeAFriendRequest(event.userTargetId);
    }else if(event is AcceptFriendRequest){
      yield* _acceptFriendRequest(event.id, event.userTargetId);
    }else if(event is GetFriendList){
      yield* _allFriend();
    }else if(event is GetOneFriend){
      yield* _getOneFriend(event.id);
    }
  }

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('api_token') ?? null);
    return token;
  }


  Stream<FriendState> _getOneFriend(String id) async* {
    try{
      yield FriendLoadingState();
      _dio.options.headers["Authorization"] = "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response res = await _dio.patch(RestClient.FRIEND_URL);
      BaseResponse baseResponse = BaseResponse.fromJson(res.data);
      if(baseResponse.status){
        yield FriendSingleLoadedState(friend: Friend.fromJson(baseResponse.data));
      }else{
        yield FriendErrorState(message: "Cannot accept friend request.");
      }
    }catch(e){
      switch(e.runtimeType){
        case DioError:
          final err = (e as DioError).response;
          print("An error occured with status code "+err.statusCode.toString());
          yield FriendErrorState(message: "Error with code:"+err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield FriendErrorState(message: "Error when requesting to server.");
      }    
    }
  }


  Stream<FriendState> _allFriend() async*{
    try{
      yield FriendLoadingState();
      _dio.options.headers["Authorization"] = "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response res = await _dio.patch(RestClient.FRIEND_URL);
      BaseListResponse baseListResponse = BaseListResponse.fromJson(res.data);
      if(baseListResponse.status){
        List<Friend> friends = List();
        for(var d in baseListResponse.data){
          friends.add(Friend.fromJson(d));
        }
        yield FriendLoadedState(friends: friends);
      }else{
        yield FriendErrorState(message: "Cannot accept friend request.");
      }
    }catch(e){
      switch(e.runtimeType){
        case DioError:
          final err = (e as DioError).response;
          print("An error occured with status code "+err.statusCode.toString());
          yield FriendErrorState(message: "Error with code:"+err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield FriendErrorState(message: "Error when requesting to server.");
      }      
    }
  }



  Stream<FriendState> _acceptFriendRequest(String id, String userTargetId) async*{
    try{
      yield FriendLoadingState();
      _dio.options.headers["Authorization"] = "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response res = await _dio.patch(RestClient.FRIEND_URL+id+"/", data: {
        "is_accepted": true
      });
      BaseResponse baseResponse = BaseResponse.fromJson(res.data);
      if(baseResponse.status){
        yield FriendSuccessState();
      }else{
        yield FriendErrorState(message: "Cannot accept friend request.");
      }
    }catch(e){
      switch(e.runtimeType){
        case DioError:
          final err = (e as DioError).response;
          print("An error occured with status code "+err.statusCode.toString());
          yield FriendErrorState(message: "Error with code:"+err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield FriendErrorState(message: "Error when requesting to server.");
      }      
    }
  }

  Stream<FriendState> _unfriend(String id) async*{
    try{
      yield FriendLoadingState();
      _dio.options.headers["Authorization"] = "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response res = await _dio.delete(RestClient.FRIEND_URL+id+"/");
      BaseResponse baseResponse = BaseResponse.fromJson(res.data);
      if(baseResponse.status){
        yield FriendSuccessState();
      }else{
        yield FriendErrorState(message: "Cannot unfriend.");
      }
    }catch(e){
      switch(e.runtimeType){
        case DioError:
          final err = (e as DioError).response;
          print("An error occured with status code "+err.statusCode.toString());
          yield FriendErrorState(message: "Error with code:"+err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield FriendErrorState(message: "Error when requesting to server.");
      }      
    }
  }


  Stream<FriendState> _makeAFriendRequest(String userTargetId) async * {
    try{
      yield FriendLoadingState();
      _dio.options.headers["Authorization"] = "Token d3b61525fb85366e5f3780266494f4bb92cb4f57";
      Response res = await _dio.post(RestClient.FRIEND_URL);
      BaseResponse baseResponse = BaseResponse.fromJson(res.data);
      if(baseResponse.status){
        yield FriendSuccessState();
      }else{
        yield FriendErrorState(message: "Cannot make a friend request");
      }
    }catch(e){
      switch(e.runtimeType){
        case DioError:
          final err = (e as DioError).response;
          print("An error occured with status code "+err.statusCode.toString());
          yield FriendErrorState(message: "Error with code:"+err.statusCode.toString());
          break;
        default:
          print("Error inside default switch case");
          yield FriendErrorState(message: "Error when requesting to server.");
      }
    }
  }
}