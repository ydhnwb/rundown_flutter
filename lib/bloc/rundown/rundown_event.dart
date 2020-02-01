import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rundown_flutter/models/rundown.dart';

abstract class RundownEvent extends Equatable{}

class FetchRundown implements RundownEvent{
  @override
  List<Object> get props => null;
}

class FetchSingleRundown implements RundownEvent{
  final String id;

  FetchSingleRundown({@required this.id});

  @override
  List<Object> get props => [id];
}

class FetchCreateRundown implements RundownEvent{
  final Rundown rundown;

  FetchCreateRundown({@required this.rundown});

  @override
  List<Object> get props => [rundown];
}