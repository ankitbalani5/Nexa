part of 'apply_coupon_bloc.dart';

@immutable
sealed class ApplyCouponState {}

final class ApplyCouponInitial extends ApplyCouponState {}
final class ApplyCouponLoading extends ApplyCouponState {}
final class ApplyCouponSuccess extends ApplyCouponState {
  ApplyCouponModel applyCouponModel;
  ApplyCouponSuccess(this.applyCouponModel);
}
final class ApplyCouponError extends ApplyCouponState {
  String error;
  ApplyCouponError(this.error);
}
