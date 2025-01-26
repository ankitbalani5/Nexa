part of 'apply_coupon_bloc.dart';

@immutable
sealed class ApplyCouponEvent {}
class ApplyNewCouponEvent extends ApplyCouponEvent {
  BuildContext context;
  List cart_ids;
  String coupon_code;
  String total_amount;
  ApplyNewCouponEvent(this.context, this.cart_ids, this.coupon_code, this.total_amount);}

class RemoveCouponEvent extends ApplyCouponEvent{}
