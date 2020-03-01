import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rundown_flutter/models/friend.dart';

abstract class FriendState extends Equatable{}

class FriendInitState implements FriendState{
  @override
  List<Object> get props => [];
}

class FriendLoadingState implements FriendState {
  @override
  List<Object> get props => [];
}

class FriendLoadedState implements FriendState {
  final List<Friend> friends;
  final List<Friend> requested;
  final List<Friend> friendRequests;
  FriendLoadedState({@required this.friends, @required this.requested, @required this.friendRequests});
  @override
  List<Object> get props => [friends];
}

class FriendSingleLoadedState implements FriendState {
  final Friend friend;
  FriendSingleLoadedState({@required this.friend});
  @override
  List<Object> get props => [friend];
}

class FriendErrorState implements FriendState {
  final String message;
  FriendErrorState({@required this.message});
  @override
  List<Object> get props => [message];
}

class FriendSuccessState implements FriendState {
  @override
  List<Object> get props => [];
}