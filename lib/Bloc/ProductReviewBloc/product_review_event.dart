part of 'product_review_bloc.dart';

@immutable
sealed class ProductReviewEvent {}
class ProductReviewLoadEvent extends ProductReviewEvent {
  String product_id;
  ProductReviewLoadEvent(this.product_id);
}
class ReviewHelpfulTapEvent extends ProductReviewEvent {
  String product_id;
  String product_review_id;
  ReviewHelpfulTapEvent(this.product_id, this.product_review_id);
}
