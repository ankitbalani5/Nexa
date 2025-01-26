part of 'all_product_bloc.dart';

@immutable
sealed class AllProductState {
}


final class AllProductInitial extends AllProductState {}
final class AllProductLoading extends AllProductState {}
final class AllProductSuccess extends AllProductState {
  AllProductModel allProductModel;
  AllProductSuccess(this.allProductModel);
}
final class AllProductError extends AllProductState {
  String error;
  AllProductError(this.error);
}
