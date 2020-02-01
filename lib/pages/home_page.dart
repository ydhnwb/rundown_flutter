import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:rundown_flutter/bloc/rundown/rundown_bloc.dart';
import 'package:rundown_flutter/bloc/rundown/rundown_event.dart';
import 'package:rundown_flutter/models/rundown.dart';
import 'package:rundown_flutter/pages/login_page.dart';
import 'package:rundown_flutter/pages/settings_page.dart';
import 'package:rundown_flutter/bloc/rundown/rundown_state.dart';
import 'package:rundown_flutter/utils/utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RundownBloc _rundownBloc;

  @override
  void initState() {
    super.initState();
    _rundownBloc = RundownBloc();
    _rundownBloc.add(FetchRundown());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.backgroundColor,
      body: Padding(
      padding: EdgeInsets.only(top: 16),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverFloatingBar(
            backgroundColor: Utils.backgroundColor,
            floating: true,
            leading: IconButton(
              icon: Icon(Icons.dehaze),
              onPressed: () {
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
                        ));
              },
            ),
            title: TextField(
              decoration: InputDecoration.collapsed(
                  hintText: "Search rundown, friends..."),
            ),
            trailing: GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white,),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingPage()));
              },
            ),
          ),
          SliverToBoxAdapter(child: BlocBuilder<RundownBloc, RundownState>(
            bloc: _rundownBloc,
            builder: (context, state) {
              if (state is RundownInitState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is RundownLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is RundownErrorState) {
                print("Show empty view...");
                return Container(
                  child: Text(state.message),
                );
              } else if (state is RundownLoadedState) {

                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top:16, left: 16, right: 16),
                          child: Neumorphic(
                            bevel: 6,
                            status: NeumorphicStatus.convex,
                            decoration: NeumorphicDecoration(borderRadius: BorderRadius.circular(26), color: Utils.backgroundColor),
                            child: IconButton(
                              icon: Icon(Icons.refresh),
                              onPressed: (){
                                _rundownBloc.add(FetchRundown());
                              },
                            ),
                          )
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 20),
                          child: _createStaggeredList(state.rundowns),
                        )
                      ],
                    );
              }
            },
          )),

        ],
      ),
    ));
  }

  Widget _createStaggeredList(List<Rundown> rundowns) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: rundowns.length,
      itemBuilder: (BuildContext context, int index) => Neumorphic(
          margin: EdgeInsets.all(6),
          status: NeumorphicStatus.convex,
          bevel: 6,
          decoration: NeumorphicDecoration(borderRadius: BorderRadius.circular(10), color: Utils.backgroundColor),
          child: InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (oontext) => SettingPage()
            )),
            child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                  Text(
                    rundowns[index].title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600]
                      ),
                      maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Text(
                        rundowns[index].description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                        style: TextStyle(
                          color: Colors.grey
                        ),
                        ),
                    )
                ],
              ),
            ),
          ),

        ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
