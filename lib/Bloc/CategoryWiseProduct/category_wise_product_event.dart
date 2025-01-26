part of 'category_wise_product_bloc.dart';

@immutable
sealed class CategoryWiseProductEvent {}
class CategoryWiseProductLoadEvent extends CategoryWiseProductEvent{
  final String category_id;
  final int page;
  final String search_keyword;
  BuildContext context;
  final String sub_category_id;
  bool pagination;
  CategoryWiseProductLoadEvent(this.category_id,  this.search_keyword, this.context,this.sub_category_id,{ this.page = 1, this.pagination = false});
}

class CategoryWishlistEvent extends CategoryWiseProductEvent{

  dynamic item;
  CategoryWishlistEvent(this.item);
}

class ClearModelEvent extends CategoryWiseProductEvent{}
class TabChangeEvent extends CategoryWiseProductEvent{}
