import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rundown_flutter/models/rundown.dart';

abstract class RundownState extends Equatable{}

class RundownInitState implements RundownState{
  @override
  List<Object> get props => [];
}

class RundownLoadingState implements RundownState {
  @override
  List<Object> get props => [];
}

class RundownLoadedState implements RundownState {
  final List<Rundown> rundowns;
  
  RundownLoadedState({@required this.rundowns});

  @override
  List<Object> get props => [rundowns];
}

class RundownSingleLoadedState implements RundownState {
  final Rundown rundown;

  RundownSingleLoadedState({@required this.rundown});

  @override
  List<Object> get props => [rundown];
}

class RundownErrorState implements RundownState {
  final String message;
  
  RundownErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}