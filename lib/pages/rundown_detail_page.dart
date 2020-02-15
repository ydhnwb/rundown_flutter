import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rundown_flutter/bloc/rundown_detail/rundown_detail_bloc.dart';
import 'package:rundown_flutter/bloc/rundown_detail/rundown_detail_event.dart';
import 'package:rundown_flutter/bloc/rundown_detail/rundown_detail_state.dart';
import 'package:rundown_flutter/models/rundown_detail.dart';
import 'package:toast/toast.dart';

class RundownDetailPage extends StatefulWidget {
  final RundownDetail rundownDetail;
  final String rundownId;
  RundownDetailPage({@required this.rundownId, this.rundownDetail});
  @override
  _RundownDetailPageState createState() => _RundownDetailPageState();
}

class _RundownDetailPageState extends State<RundownDetailPage> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController _etTitle = TextEditingController();
  TextEditingController _etDescription = TextEditingController();
  RundownDetailBloc _rundownDetailBloc;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _rundownDetailBloc = RundownDetailBloc();
    if(widget.rundownDetail != null){
      _etTitle.text = widget.rundownDetail.title;
      _etDescription.text = widget.rundownDetail.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rundown detail"),
        leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () => Navigator.pop(context)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              if(_formKey.currentState.validate()){
                String title = _etTitle.text.toString().trim();
                String desc = _etDescription.text.toString().trim();
                int id = int.parse(this.widget.rundownId);
                print(id);
                RundownDetail r = RundownDetail()
                ..title = title
                ..rundownId = id
                ..description = desc;

                if(this.widget.rundownDetail == null){
                  _rundownDetailBloc.add(FetchCreateRundownDetail(rundownDetail: r));
                }else{
                  r.id = this.widget.rundownDetail.id;
                  _rundownDetailBloc.add(FetchUpdateRundownDetail(rundownDetail: r));
                }

              }
            }
          )
        ],
      ),
      body: BlocConsumer<RundownDetailBloc, RundownDetailState>(
        bloc: _rundownDetailBloc,
        listener: (context, state){
          if(state is RundownDetailLoadingState || state is RundownDetailInitState){
            _isLoading = true;            
          }else if (state is RundownDetailErrorState){
            _showToast(state.message);
          }else if (state is RundownDetailSuccessState){
            Navigator.pop(context);
          }
        },
        builder: (context, state){
          return Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          maxLines: 3,
                          controller: _etTitle,
                          decoration: InputDecoration.collapsed(
                            hintText: "Title"
                          ),
                          validator: (v) {
                            if(v.isEmpty){
                              return "Title must not be empty";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          maxLines: null,
                          maxLength: null,
                          controller: _etDescription,
                          decoration: InputDecoration.collapsed(
                            hintText: "Description"
                          ),
                          validator: (v) {
                            if(v.isEmpty){
                              return "Description must not be empty";
                            }
                            return null;
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              _isLoading ? Center(
                child: SpinKitCubeGrid(
                  color: Theme.of(context).accentColor,
                ),
              ) : Container()
            ],
          );

        },        
      ),
      floatingActionButton: Visibility(
        visible: this.widget.rundownDetail != null,
              child: FloatingActionButton.extended(
          onPressed: (){
            if(this.widget.rundownDetail != null){
              _rundownDetailBloc.add(FetchDeleteRundownDetail(id: this.widget.rundownDetail.id.toString()));
            }
          },
          label: Text("Delete"),
          icon: Icon(Icons.delete_sweep),
          backgroundColor: Colors.redAccent[100],
        ),
      ),
    );
  }

  void _showToast(String message) { Toast.show(message, context); }

}