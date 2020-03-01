import 'dart:convert';
import 'package:chips_choice/chips_choice.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rundown_flutter/bloc/friend/friend_bloc.dart';
import 'package:rundown_flutter/bloc/friend/friend_event.dart';
import 'package:rundown_flutter/bloc/friend/friend_state.dart';
import 'package:rundown_flutter/bloc/search/search_bloc.dart';
import 'package:rundown_flutter/bloc/search/search_event.dart';
import 'package:rundown_flutter/bloc/search/search_state.dart';
import 'package:rundown_flutter/models/rundown.dart';
import 'package:rundown_flutter/models/search.dart';
import 'package:rundown_flutter/models/user.dart';
import 'package:rundown_flutter/pages/friend_request_page.dart';
import 'package:rundown_flutter/utils/utils.dart';
import 'package:toast/toast.dart';
import 'package:zefyr/zefyr.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  final String query;
  SearchPage({@required this.query});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FocusNode _searchFocusNode;
  TextEditingController _searchController = TextEditingController();
  List<String> _options = ["All", "Yours", "User"];
  int _chipsSelected = 0;
  bool _isLoading = false;
  String _currentQuery;
  SearchBloc _searchBloc;
  FriendBloc _friendBloc;
  Search _searchResult = Search()
    ..users = List<User>()
    ..rundowns = List<Rundown>();

  @override
  void initState() {
    super.initState();
    _currentQuery = this.widget.query;
    _searchController.text = _currentQuery;
    _searchBloc = SearchBloc();
    _friendBloc = FriendBloc();
    _searchBloc.add(FetchSearch(query: _currentQuery));
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
          _searchController.clear();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 16),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFloatingBar(
                leading: IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: () => Navigator.pop(context)),
                floating: true,
                automaticallyImplyLeading: true,
                title: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (v) {
                    if (v.isNotEmpty) {
                      _searchBloc.add(FetchSearch(query: v));
                    }
                  },
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration.collapsed(hintText: "Search..."),
                ),
              ),
              SliverToBoxAdapter(
                  child: BlocConsumer<SearchBloc, SearchState>(
                bloc: _searchBloc,
                listener: (context, state) {
                  if (state is SearchLoadingState) {
                    _isLoading = true;
                  } else if (state is SearchLoadedState) {
                    _isLoading = false;
                    _searchResult = state.searchResult;
                  } else {
                    _isLoading = false;
                  }
                },
                builder: (context, state) {
                  return Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              ChipsChoice.single(
                                  value: _chipsSelected,
                                  options: ChipsChoiceOption.listFrom(
                                      source: _options,
                                      value: (i, v) => i,
                                      label: (i, v) => v),
                                  onChanged: (val) =>
                                      setState(() => _chipsSelected = val)),
                              _chipsSelected == 0 &&
                                      _searchResult.rundowns.isNotEmpty
                                  ? _createStaggeredList(_searchResult.rundowns)
                                  : Container(),
                              _chipsSelected == 0 &&
                                      _searchResult.users.isNotEmpty
                                  ? _createUserList(_searchResult.users)
                                  : Container(),
                              _chipsSelected == 1
                                  ? _createStaggeredList(_searchResult.rundowns)
                                  : Container(),
                              _chipsSelected == 2 &&
                                      _searchResult.users.isNotEmpty
                                  ? _createUserList(_searchResult.users)
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                      _isLoading
                          ? Center(
                              child: Container(
                                margin:
                                    EdgeInsets.only(top: screenHeight * 0.35),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Container()
                    ],
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _createUserList(List<User> users) {
    if (users.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 16, top: 16),
            child: Text("USERS",
                style: TextStyle(
                    color: Utils.textColor, fontWeight: FontWeight.bold)),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(users.length, (i) {
                return InkWell(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => FriendRequestPage(user: users[i])));
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(users[i].name),
                          content: createButton(users[i].id.toString()),
                          actions: <Widget>[
                            FlatButton(onPressed: (){}, child: Text("Aowkowk"))
                          ],
                        );
                      }
                      );
                  },
                  child: Container(
                    margin: EdgeInsets.all(6),
                    child: ClayContainer(
                      borderRadius: 10,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(users[i].name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600]),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      );
    }
    return Container();
  }

  Widget _createStaggeredList(List<Rundown> rundowns) {
    if (rundowns.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("YOUR RUNDOWNS",
                style: TextStyle(
                    color: Utils.textColor, fontWeight: FontWeight.bold)),
          ),
          StaggeredGridView.countBuilder(
            addAutomaticKeepAlives: true,
            crossAxisCount: 4,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: rundowns.length,
            itemBuilder: (BuildContext context, int index) => Container(
              margin: EdgeInsets.all(6),
              key: PageStorageKey<String>(rundowns[index].id.toString()),
              child: Container(
                child: ClayContainer(
                  borderRadius: 10,
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                                rundownId: rundowns[index].id.toString()))),
                    onLongPress: () => {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoActionSheet(
                                cancelButton: CupertinoActionSheetAction(
                                  child: Text("Cancel"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                actions: <Widget>[
                                  CupertinoActionSheetAction(
                                    child: Text("Friendlist"),
                                    onPressed: () {
                                      print("Friendlist");
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text("Sign out"),
                                    onPressed: () {
                                      // _logout();
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ))
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            rundowns[index].title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600]),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              _notusToString(rundowns[index].description),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  String _notusToString(String js) {
    var j = json.decode(js);
    NotusDocument notus = NotusDocument.fromJson(j);
    return notus.toPlainText().toString();
  }

    Widget createButton(String userId){
      _friendBloc.add(CheckFriendshipStatus(userId: userId));
      return BlocBuilder(
        bloc: _friendBloc,
        builder: (context, state){
          if(state is FriendSingleLoadedState){
            if(state.friend == null){
              return Text("Add as a friend");
            }else{
              if(state.friend.isAccepted && !state.friend.isBlocked){
                return Text("Already a friend");
              }else if(!state.friend.isAccepted && !state.friend.isBlocked){
                if(state.friend.requestedBy.toString() ==userId){
                  return Text("Requested");
                }else{
                  return Text("Accept invitation");
                }
              }else{
                return Text("Blocked");
              }
            }
          }else if(state is FriendErrorState){
            Toast.show(state.message, context);
            return Container();
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      );
  }
}
