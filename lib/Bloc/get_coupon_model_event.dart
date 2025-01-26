part of 'get_coupon_model_bloc.dart';

@immutable
sealed class GetCouponModelEvent {}
class GetCouponLoadEvent extends GetCouponModelEvent {}
class ApplyCouponEvent extends GetCouponModelEvent {
  BuildContext context;
  List cart_ids;
  String coupon_code;
  String total_amount;
  ApplyCouponEvent(this.context, this.cart_ids, this.coupon_code, this.total_amount);
}
