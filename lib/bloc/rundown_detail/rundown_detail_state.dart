import 'package:equatable/equatable.dart';
import 'package:rundown_flutter/models/rundown_detail.dart';
import 'package:meta/meta.dart';

abstract class RundownDetailState extends Equatable{}

class RundownDetailInitState implements RundownDetailState{
  @override
  List<Object> get props => [];
}

class RundownDetailLoadingState implements RundownDetailState{
  @override
  List<Object> get props => [];
}

class RundownDetailLoadedState implements RundownDetailState{
  final List<RundownDetail> rundownDetails;
  RundownDetailLoadedState({@required this.rundownDetails});
  @override
  List<Object> get props => [rundownDetails];
}

class RundownDetailSingleLoadedState implements RundownDetailState{
  final RundownDetail rundownDetail;
  RundownDetailSingleLoadedState({@required this.rundownDetail});
  @override
  List<Object> get props => [rundownDetail]; 
}

class RundownDetailErrorState implements RundownDetailState{
  final String message;
  RundownDetailErrorState({@required this.message});
  @override
  List<Object> get props => [message];
}

class RundownDetailSuccessState implements RundownDetailState{
  @override
  List<Object> get props => [];  
}