import 'dart:convert';
import 'package:clay_containers/clay_containers.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rundown_flutter/bloc/rundown/rundown_bloc.dart';
import 'package:rundown_flutter/bloc/rundown/rundown_event.dart';
import 'package:rundown_flutter/models/rundown.dart';
import 'package:rundown_flutter/pages/rundown_page.dart';
import 'package:rundown_flutter/pages/detail_page.dart';
import 'package:rundown_flutter/pages/login_page.dart';
import 'package:rundown_flutter/pages/settings_page.dart';
import 'package:rundown_flutter/bloc/rundown/rundown_state.dart';
import 'package:rundown_flutter/utils/utils.dart';
import 'package:zefyr/zefyr.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  RundownBloc _rundownBloc;
  FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _rundownBloc = RundownBloc();
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener((){});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rundownBloc.add(FetchRundown());
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async{
        
        if(_searchFocusNode.hasFocus){

          _searchFocusNode.unfocus();
          print(_searchFocusNode.hasFocus);
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
                floating: true,
                automaticallyImplyLeading: true,
                title: TextField(
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration.collapsed(

                      hintText: "Search rundown, friends..."),
                ),
                trailing: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingPage()));
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: BlocBuilder<RundownBloc, RundownState>(
                bloc: _rundownBloc,
                builder: (context, state) {
                  if (state is RundownInitState) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.only(top: screenHeight*0.35),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is RundownLoadingState) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.only(top: screenHeight*0.35),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is RundownErrorState) {
                    return _errorView(state.message, true);
                  } else if (state is RundownLoadedState) {
                    if (state.rundowns.isEmpty) {
                      return _errorView("Nothing for now", false);
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              top: 0, left: 16, right: 16, bottom: 20),
                          child: _createStaggeredList(state.rundowns),
                        )
                      ],
                    );
                  }
                },
              )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => CreateRundownPage()
              ));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  Widget _createStaggeredList(List<Rundown> rundowns) {
    return StaggeredGridView.countBuilder(
      addAutomaticKeepAlives: true,
      crossAxisCount: 4,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: rundowns.length,
      itemBuilder: (BuildContext context, int index) => Container(
        margin: EdgeInsets.all(6),
        key: PageStorageKey<String>(rundowns[index].id.toString()),
        child: ClayContainer(
          borderRadius: 10,
          child: InkWell(
            onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => 
                DetailPage(rundownId: rundowns[index].id.toString())
              )),
            onLongPress: () => {
              showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => CupertinoActionSheet(
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
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
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
                        fontWeight: FontWeight.bold, color: Colors.grey[600]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: 
                    Text(_notusToString(rundowns[index].description),
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
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Widget _errorView(String err, bool isError) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    var image = isError? Image.asset(Utils.doodleClumsy, height: screenHeight/3.5, width: screenWidth/2) 
    : Image.asset(Utils.doodleMeditating, height: screenHeight/3.5, width: screenWidth/2,) ;
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 96),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            image,
            Container(
              margin: EdgeInsets.only(top: 16),
              child: FlatButton(onPressed: (){
                _rundownBloc.add(FetchRundown());
              }, child: Text("Nothing for now. Tap to refresh")),
            )
          ],
        ),
      ),
    );
  }

  String _notusToString(String js){
    var j = json.decode(js);
    NotusDocument notus = NotusDocument.fromJson(j);
    return notus.toPlainText().toString();
  }
}
