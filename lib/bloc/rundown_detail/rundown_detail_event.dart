import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:rundown_flutter/models/rundown_detail.dart';

abstract class RundownDetailEvent extends Equatable{}

class FetchSingleRundownDetail implements RundownDetailEvent {
  final String id;
  FetchSingleRundownDetail({@required this.id});
  @override
  List<Object> get props => [id];
}

class FetchCreateRundownDetail implements RundownDetailEvent{
  final RundownDetail rundownDetail;
  FetchCreateRundownDetail({@required this.rundownDetail});
  @override
  List<Object> get props => [rundownDetail];
}

class FetchUpdateRundownDetail implements RundownDetailEvent{
  final RundownDetail rundownDetail;
  FetchUpdateRundownDetail({@required this.rundownDetail});
  @override
  List<Object> get props => [rundownDetail];
}

class FetchDeleteRundownDetail implements RundownDetailEvent{
  final String id;
  FetchDeleteRundownDetail({@required this.id});
  @override
  List<Object> get props => [id];
}