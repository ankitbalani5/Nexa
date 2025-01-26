part of 'sub_category_bloc.dart';

@immutable
sealed class SubCategoryEvent {}
class SubCategoryLoadEvent extends SubCategoryEvent{
  String category_id;
  String sub_cat_id;
  int page;
  String search_keyword;
  var pagination;
  SubCategoryLoadEvent(this.category_id, this.sub_cat_id, this.page, this.search_keyword, this.pagination);
}

class AddWishlistEvent extends SubCategoryEvent{
  String product_id;
  AddWishlistEvent(this.product_id);
}

class DataClearEvent extends SubCategoryEvent{}
