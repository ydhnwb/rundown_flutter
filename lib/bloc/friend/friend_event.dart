import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class FriendEvent extends Equatable{}

class GetFriendList implements FriendEvent{
  @override
  List<Object> get props => null;
}

class GetOneFriend implements FriendEvent{
  final String id;
  GetOneFriend({@required this.id});
  @override
  List<Object> get props => [id];
}

class SendFriendRequest implements FriendEvent{
  final String userTargetId;
  SendFriendRequest({@required this.userTargetId});
  @override
  List<Object> get props => [userTargetId];
}

class AcceptFriendRequest implements FriendEvent{
  final String id, userTargetId;
  AcceptFriendRequest({@required this.id, @required this.userTargetId});
  @override
  List<Object> get props => [id, userTargetId];
}

class Unfriend implements FriendEvent {
  final String id, userTargetId;
  Unfriend({@required this.id, @required this.userTargetId});
  @override
  List<Object> get props => [id, userTargetId];
}

class CheckFriendshipStatus implements FriendEvent {
  final String userId;
  CheckFriendshipStatus({@required this.userId});

  @override
  List<Object> get props => [userId];
  
}