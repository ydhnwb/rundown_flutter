import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SearchEvent extends Equatable{}

class FetchSearch implements SearchEvent{
  final String query;
  FetchSearch({@required this.query});
  @override
  List<Object> get props => [query];
}