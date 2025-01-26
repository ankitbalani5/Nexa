import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Model/GetCouponModel.dart';

part 'get_coupon_model_event.dart';
part 'get_coupon_model_state.dart';

class GetCouponModelBloc extends Bloc<GetCouponModelEvent, GetCouponModelState> {
  GetCouponModel?  _productData;
  String _message = '';
  double _discount = 0;
  double _totalAmount = 0;
  String _couponCode = '';

  String get message => _message;
  double get discount => _discount;
  double get totalAmount => _totalAmount;
  String get couponCode => _couponCode;

  GetCouponModelBloc() : super(GetCouponModelInitial()) {
    on<GetCouponLoadEvent>(_loadCoupon);
    on<ApplyCouponEvent>(_applyCoupon);
  }



  Future<void> _loadCoupon(GetCouponLoadEvent event, Emitter<GetCouponModelState> emit) async {
    emit(GetCouponModelLoading());
    try{
      final response = await Api.getCouponApi();
      if(response != null){
        _productData = response;
        emit(GetCouponModelSuccess(response));
      }
    }on SocketException{
      emit(GetCouponModelError('Please check your internet connection'));
    }catch(e){
      emit(GetCouponModelError(e.toString()));
    }
  }

//   _applyCoupon(ApplyCouponEvent event, Emitter<GetCouponModelState> emit) async {
//     // emit(GetCouponModelLoading());
//     final index = _productData?.availableCoupon?.indexWhere((e) => e.code == event.coupon_code);
//     if (index != null && index != -1) {
//       // Set the coupon to loading state
//       final updatedCoupon = _productData!.availableCoupon![index].copyWith(loading: true);
//       final updatedCoupons = List<AvailableCoupon>.from(_productData!.availableCoupon!);
//       updatedCoupons[index] = updatedCoupon;
//
//       // Emit updated state with loading indicator
//       emit(GetCouponModelSuccess(
//           _productData!.copyWith(availableCoupon: updatedCoupons)
//       ));
//
//       final response = await Api.applyCouponApi(event.cart_ids.join(','), event.coupon_code, event.total_amount);
//       if(response != null){
//         emit(GetCouponModelSuccess(_productData!));
//         _message = response.message ?? "No message"; // Default message handling
//
//         // Safely parse totalPrice and discountPrice to integers with fallback to 0
//         _totalAmount = _tryParseToInt(response.totalPrice);
//         _couponCode = response.couponCode ?? "No coupon"; // Default coupon code handling
//         _discount = _tryParseToInt(response.discountPrice);
//       }
//     }
//
// }

  _applyCoupon(ApplyCouponEvent event, Emitter<GetCouponModelState> emit) async {
    final index = _productData?.availableCoupon?.indexWhere((e) => e.code == event.coupon_code);

    if (index != null && index != -1) {
      // Set the coupon to loading state
      final updatedCoupon = _productData!.availableCoupon![index].copyWith(loading: true);
      final updatedCoupons = List<AvailableCoupon>.from(_productData!.availableCoupon!);
      updatedCoupons[index] = updatedCoupon;
      _productData = _productData!.copyWith(availableCoupon: updatedCoupons);

      // Emit updated state with loading indicator
      // emit(GetCouponModelSuccess(_productData!));
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
          }

          Navigator.pop(event.context);
          // Remove loading state after success
          final updatedCouponSuccess = updatedCoupon.copyWith(loading: false);
          updatedCoupons[index] = updatedCouponSuccess;
          _productData = _productData!.copyWith(availableCoupon: updatedCoupons);

          emit(GetCouponModelSuccess(_productData!));
        } else {
          throw Exception("Failed to apply coupon");
        }
      } catch (e) {
        // Handle error and stop loading state
        final updatedCouponError = updatedCoupon.copyWith(loading: false);
        updatedCoupons[index] = updatedCouponError;
        emit(GetCouponModelError(e.toString()));
      }
    }else{
      emit(GetCouponModelError('No coupon'));
      // Fluttertoast.showToast(msg: 'No coupon', backgroundColor: Constant.bgOrangeLite);
    }
  }


// Helper function to safely parse a string to an integer with a fallback to 0
  int _tryParseToInt(String? value) {
    if (value == null || value.isEmpty) {
      return 0; // Fallback to 0 if null or empty
    }
    return int.tryParse(value) ?? 0; // Fallback to 0 if parsing fails
  }
}
