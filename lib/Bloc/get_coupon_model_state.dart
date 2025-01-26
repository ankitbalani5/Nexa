part of 'get_coupon_model_bloc.dart';

@immutable
sealed class GetCouponModelState {}

final class GetCouponModelInitial extends GetCouponModelState {}
final class GetCouponModelLoading extends GetCouponModelState {}
final class GetCouponModelSuccess extends GetCouponModelState {
  GetCouponModel getCouponModel;
  GetCouponModelSuccess(this.getCouponModel);
}
final class GetCouponModelError extends GetCouponModelState {
  String error;
  GetCouponModelError(this.error);
}
