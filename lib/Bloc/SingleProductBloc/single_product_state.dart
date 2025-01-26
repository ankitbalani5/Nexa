part of 'single_product_bloc.dart';

@immutable
sealed class SingleProductState {}

final class SingleProductInitial extends SingleProductState {}
final class SingleProductLoading extends SingleProductState {}
final class SingleProductSuccess extends SingleProductState {
  SingleProductModel singleProductModel;
  final int counter;
  SingleProductSuccess(this.singleProductModel, {this.counter = 1});
}
final class SingleProductError extends SingleProductState {
  String error;
  SingleProductError(this.error);
}
