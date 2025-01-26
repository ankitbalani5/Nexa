part of 'cart_products_bloc.dart';

@immutable
abstract class CartProductsState {}

class CartProductsInitial extends CartProductsState {}
class CartProductsLoading extends CartProductsState {}
class CartProductsSuccess extends CartProductsState {
  CartProductsModel cartProductsModel;
  final bool cartDeleted;
  final bool cartIncrease;
  final bool cartDecrease;

  CartProductsSuccess(this.cartProductsModel, {this.cartDeleted = false, this.cartIncrease = false, this.cartDecrease = false});
}
class CartProductsError extends CartProductsState {
  String error;
  CartProductsError(this.error);
}
