part of 'review_helpful_bloc.dart';

@immutable
sealed class ReviewHelpfulEvent {}
class ReviewHelpfulTapEvent extends ReviewHelpfulEvent {
  String product_id;
  String product_review_id;
  ReviewHelpfulTapEvent(this.product_id, this.product_review_id);
}
