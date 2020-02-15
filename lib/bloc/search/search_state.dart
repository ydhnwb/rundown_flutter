import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rundown_flutter/models/search.dart';


abstract class SearchState extends Equatable{}

class SearchInitState implements SearchState{
  @override
  List<Object> get props => [];
}

class SearchLoadingState implements SearchState{
  @override
  List<Object> get props => [];
}

class SearchLoadedState implements SearchState{
  final Search searchResult;
  SearchLoadedState({@required this.searchResult});
  @override
  List<Object> get props => [searchResult];
}

class SearchErrorState implements SearchState {
  final String message;
  SearchErrorState({@required this.message});
  @override
  List<Object> get props => [message];
}