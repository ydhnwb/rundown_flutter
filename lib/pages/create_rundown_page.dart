import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rundown_flutter/bloc/rundown/rundown_bloc.dart';
import 'package:rundown_flutter/bloc/rundown/rundown_event.dart';
import 'package:rundown_flutter/bloc/rundown/rundown_state.dart';
import 'package:rundown_flutter/models/rundown.dart';
import 'package:zefyr/zefyr.dart';
import 'package:toast/toast.dart';

class CreateRundownPage extends StatefulWidget {
  final Rundown rundown;
  CreateRundownPage({this.rundown});

  @override
  _CreateRundownPageState createState() => _CreateRundownPageState();
}

class _CreateRundownPageState extends State<CreateRundownPage> {
  ZefyrController _zefyrController;
  TextEditingController _textEditingController;
  FocusNode _focusNode;
  NotusDocument _notusDocument;
  RundownBloc _rundownBloc;
  bool _isLoading = false;
  Rundown _tempRundown;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();

    if(widget.rundown != null){
      print(json.decode(widget.rundown.description));
      _tempRundown = widget.rundown;
      _textEditingController.text = widget.rundown.title;
      _notusDocument = NotusDocument.fromJson(json.decode(widget.rundown.description));
    }else{
      _notusDocument = NotusDocument();
    }
    _zefyrController = ZefyrController(_notusDocument);
    _focusNode = FocusNode();
    _rundownBloc = RundownBloc();

  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final form = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _textEditingController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration.collapsed(hintText: "Title"),
            ),
            Divider(),
            Stack(
              children: <Widget>[
                Text(
                  "Please write the decription below",
                  style: TextStyle(color: Colors.grey),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: ZefyrField(
                    controller: _zefyrController,
                    focusNode: _focusNode,
                    height: screenHeight * 0.71,
                    physics: ClampingScrollPhysics(),
                    decoration: InputDecoration.collapsed(
                      hintText: " "
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text( _tempRundown.id != null ? "update" : "Create new",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => Navigator.pop(context)),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done, color: Theme.of(context).accentColor),
              onPressed: () {
                if(_textEditingController.text.toString().trim().isEmpty || _notusDocument.toPlainText().trim().isEmpty){
                  _showToast("Please fill with title and description");
                }else{
                  if(_textEditingController.text.toString().trim().length < 250){
                    _showToast("The title is too long");
                  }else{
                    print(json.encode(_notusDocument.toDelta()));
                    var x = json.encode(_notusDocument.toDelta());
                    Rundown r = Rundown()
                    ..title = _textEditingController.text.toString().trim()
                    ..description = x;
                  _rundownBloc.add(widget.rundown != null ? FetchUpdateRundown(rundown: r) : FetchCreateRundown(rundown: r));
                  }
                }
              })
        ],
      ),
      body: BlocListener(
        bloc: _rundownBloc,
        listener: (context, state){
          if(state is RundownLoadingState){
            _isLoading = true;
          }else if (state is RundownSuccessState){
            if(widget.rundown != null){
              _showToast("Successfully updated!");
            }else{
              _showToast("Successfully created");
            }
            Navigator.pop(context);
          }else{
            _isLoading = false;
          }
        },
        child: ZefyrScaffold(
          child: Stack(
            children: <Widget>[
              _isLoading? Center(
                child: CircularProgressIndicator(),
              ) : Container(),
              form
            ],
          )
          )),
    );
  }

  _showToast(String message) => Toast.show(message, context);
  
}
