part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}
class HomeRefreshEvent extends HomeEvent {
  String category_name;
  String product_name;
  HomeRefreshEvent(this.category_name, this.product_name);
}

class AddHomeWishlistEvent extends HomeEvent {
  dynamic item;
  AddHomeWishlistEvent(this.item);
}

class HomeLogoutEvent extends HomeEvent{}
