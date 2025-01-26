part of 'all_product_bloc.dart';

@immutable
sealed class AllProductEvent {}
class AllProductRefreshEvent extends AllProductEvent {
  String brand_id;
  String price_min;
  String price_max;
  String rating;
  String price_ranges;
  String discount;
  String top_sale;
  String price_sorting;
  int page;
  final pagination;
  AllProductRefreshEvent(
      this.brand_id,
      this.price_min,
      this.price_max,
      this.rating,
      this.price_ranges,
      this.discount,
      this.top_sale,
      this.price_sorting,
      {this.page = 1, this.pagination = false});
}

class SortProductEvent extends AllProductEvent {
  var brand_id;
  String price_min;
  String price_max;
  var rating;
  var price_ranges;
  var discount;
  String top_sale;
  String price_sorting;
  int page;
  final pagination;
  final filter;
  BuildContext context;
  SortProductEvent(
      this.brand_id,
      this.price_min,
      this.price_max,
      this.rating,
      this.price_ranges,
      this.discount,
      this.top_sale,
      this.price_sorting,
      {this.page = 1, this.pagination = false, this.filter = false, required this.context});
}

class AddWishlistEvent extends AllProductEvent{
  String product_id;
  AddWishlistEvent(this.product_id);
}

class DataClearEvent extends AllProductEvent{
  // String product_id;
  // AddWishlistEvent();
}
