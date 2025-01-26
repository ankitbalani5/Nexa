part of 'suggestion_bloc.dart';

@immutable
sealed class SuggestionState {}

final class SuggestionInitial extends SuggestionState {}
final class SuggestionLoading extends SuggestionState {}
final class SuggestionSuccess extends SuggestionState {
  SuggestionModel suggestionModel;
  SuggestionSuccess(this.suggestionModel);
}
final class SuggestionError extends SuggestionState {
  String error;
  SuggestionError(this.error);
}
