part of 'product_review_bloc.dart';

@immutable
sealed class ProductReviewState {}

final class ProductReviewInitial extends ProductReviewState {}
final class ProductReviewLoading extends ProductReviewState {}
final class ProductReviewSuccess extends ProductReviewState {
  ProductReviewModel productReviewModel;
  ProductReviewSuccess(this.productReviewModel);
}
final class ProductReviewError extends ProductReviewState {
  String error;
  ProductReviewError(this.error);
}
