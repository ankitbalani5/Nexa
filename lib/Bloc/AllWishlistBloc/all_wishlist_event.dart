part of 'all_wishlist_bloc.dart';

@immutable
sealed class AllWishlistEvent {}

class WishlistRefreshEvent extends AllWishlistEvent {}

class RemoveWishlistEvent extends AllWishlistEvent {
  dynamic item;
  RemoveWishlistEvent(this.item);
}

class AddToCartWishlistEvent extends AllWishlistEvent {
  dynamic item;
  AddToCartWishlistEvent(this.item);
}

class WishlistLogoutEvent extends AllWishlistEvent{}