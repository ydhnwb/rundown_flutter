import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rundown_flutter/bloc/friend/friend_bloc.dart';
import 'package:rundown_flutter/bloc/friend/friend_event.dart';
import 'package:rundown_flutter/bloc/friend/friend_state.dart';
import 'package:rundown_flutter/models/friend.dart';
import 'package:rundown_flutter/models/user.dart';
import 'package:toast/toast.dart';

class FriendRequestPage extends StatefulWidget {
  final User user;
  FriendRequestPage({@required this.user});
  @override
  _FriendRequestPageState createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  User _selectedUser = User();
  FriendBloc _friendBloc;
  bool _isLoading = false;
  Friend _fetchedFriend;

  @override
  void initState() {
    super.initState();
    _selectedUser = this.widget.user;
    _friendBloc = FriendBloc();
    _friendBloc.add(CheckFriendshipStatus(userId: _selectedUser.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Person"),
      ),
      body: BlocConsumer(
        bloc: _friendBloc,
        builder: (context, state){
          return Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(_selectedUser.name),
                      Row(
                        children: <Widget>[
                          createButton()
                        ],
                      )
                    ],
                  )
                ),
              ),

              _isLoading ? Center(
                child: CircularProgressIndicator(),
              ) : Container()

            ],
          );
        },
        listener: (context, state){
          if(state is FriendLoadingState){
            _isLoading = true;
          }else if(state is FriendSingleLoadedState){
            _isLoading = false;
            _fetchedFriend = state.friend;
          }else if(state is FriendErrorState){
            _isLoading = false;
            Toast.show(state.message, context);
          }else{
            _isLoading = false;
          }
        }
      ),
    );
  }

  Widget createButton(){
    if(_fetchedFriend == null){
      return Text("Add as a friend");
    }else{
      if(_fetchedFriend.isAccepted && !_fetchedFriend.isBlocked){
        return Text("Already a friend");
      }else if(!_fetchedFriend.isAccepted && !_fetchedFriend.isBlocked){
        return Text("Requestedd");
      }else{
        return Text("Blocked");
      }
    }
  }
}