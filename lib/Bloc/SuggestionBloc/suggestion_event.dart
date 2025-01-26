part of 'suggestion_bloc.dart';

@immutable
sealed class SuggestionEvent {}
class SuggestionLoadEvent extends SuggestionEvent {
  String keyword;
  SuggestionLoadEvent(this.keyword);
}
