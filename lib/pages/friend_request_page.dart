import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rundown_flutter/bloc/friend/friend_bloc.dart';
import 'package:rundown_flutter/bloc/friend/friend_event.dart';
import 'package:rundown_flutter/bloc/friend/friend_state.dart';
import 'package:rundown_flutter/models/friend.dart';
import 'package:rundown_flutter/models/user.dart';

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
  Friend _friend = Friend();

  @override
  void initState() {
    super.initState();
    _selectedUser = this.widget.user;
    _friendBloc = FriendBloc();
    _friendBloc.add(GetOneFriend(id: _selectedUser.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _friend = state.friend;
          }else{
            _isLoading = false;
          }
        }
      ),
    );
  }

  Widget createButton(){
    if(_friend == null){
      return FlatButton(onPressed: (){}, child: Text("Make a friend request"));
    }else{
      if(!_friend.isBlocked){
        if(_friend.isAccepted){
          return Text("You already a friend");
        }else{
          return Text("Requested");
        }
      }else{
        return Container();
      }
    }
  }
}