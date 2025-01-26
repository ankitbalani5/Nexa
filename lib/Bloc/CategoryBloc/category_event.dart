part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}
class CategoryRefreshEvent extends CategoryEvent {
  String category_name;
  CategoryRefreshEvent(this.category_name);
}

class AddCategoryWishlistEvent extends CategoryEvent{
  dynamic item;
  AddCategoryWishlistEvent(this.item);
}

class AddCategoryWishlistWithTapEvent extends CategoryEvent{
  dynamic item;
  AddCategoryWishlistWithTapEvent(this.item);
}

class CategoryLogoutEvent extends CategoryEvent{}
