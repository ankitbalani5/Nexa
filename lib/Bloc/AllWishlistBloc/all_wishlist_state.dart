part of 'all_wishlist_bloc.dart';

@immutable
sealed class AllWishlistState {}

final class AllWishlistInitial extends AllWishlistState {}
final class AllWishlistLoading extends AllWishlistState {}
final class AllWishlistSuccess extends AllWishlistState {
  AllWishlistModel allWishlistModel;
  AllWishlistSuccess(this.allWishlistModel);
}
final class AllWishlistError extends AllWishlistState {
  String error;
  AllWishlistError(this.error);
}
