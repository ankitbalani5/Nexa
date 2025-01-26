part of 'review_helpful_bloc.dart';

@immutable
sealed class ReviewHelpfulState {}

final class ReviewHelpfulInitial extends ReviewHelpfulState {}
final class ReviewHelpfulLoading extends ReviewHelpfulState {}
final class ReviewHelpfulSuccess extends ReviewHelpfulState {
  ReviewHelpfulModel reviewHelpfulModel;
  ReviewHelpfulSuccess(this.reviewHelpfulModel);
}
final class ReviewHelpfulError extends ReviewHelpfulState {
  String error;
  ReviewHelpfulError(this.error);
}
