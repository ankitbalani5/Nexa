part of 'category_wise_product_bloc.dart';

@immutable
sealed class CategoryWiseProductState {}

final class CategoryWiseProductInitial extends CategoryWiseProductState {}
final class CategoryWiseProductLoading extends CategoryWiseProductState {}
final class CategoryWiseProductSuccess extends CategoryWiseProductState {
  CategoryWiseProductModel categoryWiseProductModel;
  CategoryWiseProductSuccess(this.categoryWiseProductModel);
}
final class CategoryWiseProductError extends CategoryWiseProductState {
  String error;
  CategoryWiseProductError(this.error);
}
