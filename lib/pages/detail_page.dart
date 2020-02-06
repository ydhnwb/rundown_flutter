import 'dart:convert';
import 'dart:developer';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rundown_flutter/bloc/rundown/rundown_bloc.dart';
import 'package:rundown_flutter/bloc/rundown/rundown_event.dart';
import 'package:rundown_flutter/bloc/rundown/rundown_state.dart';
import 'package:rundown_flutter/components/rundown_detail_component.dart';
import 'package:rundown_flutter/models/rundown_detail.dart';
import 'package:rundown_flutter/pages/rundown_detail_page.dart';
import 'package:rundown_flutter/pages/rundown_page.dart';
import 'package:rundown_flutter/utils/utils.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:zefyr/zefyr.dart';

class DetailPage extends StatefulWidget {
  final String rundownId;

  DetailPage({Key key, @required this.rundownId}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  RundownBloc _rundownBloc = RundownBloc();
  bool _isPressed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rundownBloc.add(FetchSingleRundown(id: this.widget.rundownId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RundownDetailPage(
            rundownId: this.widget.rundownId,
          ))),
          backgroundColor: Theme.of(context).accentColor,
          child: Icon(Icons.add, color: Colors.white),
        ),
        body: BlocListener<RundownBloc, RundownState>(
          bloc: _rundownBloc,
          listener: (context, state) {
            if (state is RundownSuccessState) {
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<RundownBloc, RundownState>(
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
                  return Center(child: Text(state.message));
                } else if (state is RundownSingleLoadedState) {
                  return Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ClayContainer(
                              borderRadius: 20,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 116, left: 26, right: 26, bottom: 26),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      state.rundown.title,
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Utils.textColor),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 16, bottom: 16),
                                      child: _renderNotus(
                                          state.rundown.description),
                                    ),
                                    Text(state.rundown.rundownDetails.length
                                            .toString() +
                                        " items"),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(8),
                                              child: ClayContainer(
                                                surfaceColor:
                                                    Colors.redAccent[100],
                                                borderRadius: 75,
                                                child: IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () async {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "Delete this?"),
                                                              content: Text(
                                                                  "All the child items will be deleted too and your friends who have this copy still have it"),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context),
                                                                    child: Text(
                                                                        "CANCEL")),
                                                                FlatButton(
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                      _rundownBloc.add(FetchDeleteRundown(
                                                                        id: state
                                                                            .rundown
                                                                            .id
                                                                            .toString())); 
                                                                    },
                                                                    child: Text(
                                                                        "DELETE"))
                                                              ],
                                                            );
                                                          });
                                                    }),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8),
                                              child: ClayContainer(
                                                borderRadius: 75,
                                                child: IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: Colors.grey[600],
                                                    ),
                                                    onPressed: () {
                                                      print("idnyaaa "+state.rundown.id.toString());
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CreateRundownPage(
                                                                    rundown: state
                                                                        .rundown))
                                                                        );
                                                    }
                                                                        ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8),
                                              child: ClayContainer(
                                                borderRadius: 75,
                                                child: IconButton(
                                                    icon: Icon(
                                                      Icons.sort,
                                                      color: Colors.grey[600],
                                                    ),
                                                    onPressed: () {
                                                      print("reorder");
                                                    },
                                              ),
                                            ),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: state.rundown.rundownDetails.isNotEmpty
                                  ? _generateRundownDetail(
                                      state.rundown.rundownDetails)
                                  : Text("Nothing"),
                            )
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              top: 46, left: 16, right: 16, bottom: 16),
                          child: ClayContainer(
                            borderRadius: 75,
                            curveType: _isPressed
                                ? CurveType.concave
                                : CurveType.convex,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPressed = true;
                                });

                                Navigator.pop(context);
                                Future.delayed(const Duration(milliseconds: 50),
                                    () {
                                  setState(() {
                                    _isPressed = false;
                                  });
                                });
                              },
                            ),
                          )),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
        ));
  }

  Widget _generateRundownDetail(List<RundownDetail> rundownDetails) {
    List<TimelineModel> items = List();
    for (var rd in rundownDetails) {
      items.add(TimelineModel(RundownDetailComponent(rundownDetail: rd, rundownId: this.widget.rundownId,),
          position: TimelineItemPosition.right,
          icon: Icon(Icons.info, color: Utils.textColor)));
    }

    return Timeline(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: items,
        position: TimelinePosition.Left);
  }

  Widget _renderNotus(String desc) {
    var j = json.decode(desc);
    NotusDocument notusDocument = NotusDocument.fromJson(j);
    return ZefyrView(
      document: notusDocument,
    );
  }
}
