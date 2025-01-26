import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';

import '../../Api.dart';
import '../../Constant.dart';
import '../../Model/ApplyCouponModel.dart';

part 'apply_coupon_event.dart';
part 'apply_coupon_state.dart';

class ApplyCouponBloc extends Bloc<ApplyCouponEvent, ApplyCouponState> {
  String _message = '';
  double _discount = 0;
  double _totalAmount = 0;
  String _couponCode = '';

  String get message => _message;
  double get discount => _discount;
  double get totalAmount => _totalAmount;
  String get couponCode => _couponCode;

  ApplyCouponBloc() : super(ApplyCouponInitial()) {
    on<ApplyNewCouponEvent>(_applyCoupon);
    on<RemoveCouponEvent>(_removeCoupon);
  }

  // _applyCoupon(ApplyNewCouponEvent event, Emitter<ApplyCouponState> emit) async {
  //   emit(ApplyCouponLoading());
  //   final response = await Api.applyCouponApi(event.cart_ids.join(','), event.coupon_code, event.total_amount);
  //   if(response != null){
  //     emit(ApplyCouponSuccess(response));
  //     _message = response.message ?? "No message"; // Default message handling
  //
  //     // Safely parse totalPrice and discountPrice to integers with fallback to 0
  //     _totalAmount = _tryParseToInt(response.totalPrice);
  //     _couponCode = response.couponCode ?? "No coupon"; // Default coupon code handling
  //     _discount = _tryParseToInt(response.discountPrice);
  //   }
  // }

  _applyCoupon(ApplyNewCouponEvent event, Emitter<ApplyCouponState> emit) async {
      Constant.showDialogProgress(event.context);

      try {
        final response = await Api.applyCouponApi(event.cart_ids.join(','), event.coupon_code, event.total_amount);
        if (response != null) {

          _message = response.message ?? "No message";

          if(response.status != false){
            _totalAmount = double.parse(response.totalPrice.toString()) ;
            _couponCode = response.couponCode ?? "No coupon";
            _discount = double.parse(response.discountPrice.toString());
          }else{
            _totalAmount = double.parse(event.total_amount.toString());
            _couponCode = "";
            _discount = 0.0;
            Fluttertoast.showToast(msg: response.message.toString(), backgroundColor: Constant.bgOrangeLite);
          }

          Navigator.pop(event.context);

          emit(ApplyCouponSuccess(response!));
        } else {
          Navigator.pop(event.context);
          throw Exception("Failed to apply coupon");
        }
      } catch (e) {
        Navigator.pop(event.context);
        // Handle error and stop loading state
        // final updatedCouponError = updatedCoupon.copyWith(loading: false);
        // updatedCoupons[index] = updatedCouponError;
        emit(ApplyCouponError(e.toString()));
      }
    // }else{
    //   emit(GetCouponModelError('No coupon'));
    //   // Fluttertoast.showToast(msg: 'No coupon', backgroundColor: Constant.bgOrangeLite);
    // }
  }

  _removeCoupon(RemoveCouponEvent event, Emitter<ApplyCouponState> emit){
    _discount = 0.0;
  }

  int _tryParseToInt(String? value) {
    if (value == null || value.isEmpty) {
      return 0; // Fallback to 0 if null or empty
    }
    return int.tryParse(value) ?? 0; // Fallback to 0 if parsing fails
  }
}
