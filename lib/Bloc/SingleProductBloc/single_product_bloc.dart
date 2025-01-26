import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/Model/SingleProductModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constant.dart';

part 'single_product_event.dart';
part 'single_product_state.dart';

class SingleProductBloc extends Bloc<SingleProductEvent, SingleProductState> {
  int _counter = 1;
  SingleProductModel? _productData;
  SingleProductBloc() : super(SingleProductInitial()) {
    on<IncreaseItemEvent>(_increment);
    on<DecreaseItemEvent>(_decrement);
    on<AddCartEvent>(_addtoCart);
    on<AddWishlistSingleEvent>(_addWishlist);
    on<SingleProductRefreshEvent>(_fetchSingleProduct);
  }

  void _increment(IncreaseItemEvent event, Emitter<SingleProductState> emit) {
    var updateProduct = _productData?.product?.copyWith(
      counter: _productData!.product!.counter! + 1
    );

    var updateProductData = _productData?.copyWith(
      product: updateProduct
    );

    _productData = updateProductData;
    emit(SingleProductSuccess(_productData!));

    // if (state is SingleProductSuccess) {
    //   final currentState = state as SingleProductSuccess;
    //   final updatedCounter = currentState.counter + 1;
    //   emit(SingleProductSuccess(currentState.singleProductModel, counter: updatedCounter));
    // }
  }

  void _decrement(DecreaseItemEvent event, Emitter<SingleProductState> emit) {
    var updateProduct = _productData?.product?.copyWith(
        counter: _productData!.product!.counter! - 1
    );

    var updateProductData = _productData?.copyWith(
        product: updateProduct
    );

    _productData = updateProductData;
    emit(SingleProductSuccess(_productData!));
    // if (state is SingleProductSuccess) {
    //   final currentState = state as SingleProductSuccess;
    //   final updatedCounter = currentState.counter > 1 ? currentState.counter - 1 : 1;
    //   emit(SingleProductSuccess(currentState.singleProductModel, counter: updatedCounter));
    // }
  }

  Future<void> _addtoCart(AddCartEvent event, Emitter<SingleProductState> emit) async {
    var index = _productData?.product?.productId == int.parse(event.product_id);
    print('index $index');
    if(index == true){
      var updateProduct = _productData!.product!.copyWith(
          cartloading: _productData!.product!.cartloading == true ? false : true
      );
      var updatedProduct = _productData!.copyWith(
          product: updateProduct
      );

      _productData = updatedProduct;
      emit(SingleProductSuccess(_productData!));

      await Api.addToCartApi(event.product_id, event.quantity, event.price).then((value) {
        if(value?.status == 'success'){
          var updateProduct = _productData!.product!.copyWith(
              cartloading: _productData!.product!.cartloading = false,
            cart: true
          );
          var updatedProduct = _productData!.copyWith(
              product: updateProduct,
          );

          _productData = updatedProduct;
          emit(SingleProductSuccess(_productData!));
          Fluttertoast.showToast(msg: value!.message.toString(), backgroundColor: Constant.bgOrangeLite);
        }else{
          var updateProduct = _productData!.product!.copyWith(
              cartloading: _productData!.product!.cartloading = false,
            cart: true
          );
          var updatedProduct = _productData!.copyWith(
              product: updateProduct,
          );

          _productData = updatedProduct;
          emit(SingleProductSuccess(_productData!));
          Fluttertoast.showToast(msg: value!.message.toString(), backgroundColor: Constant.bgOrangeLite);
        }
      });
    }
  }

  Future<void> _addWishlist(AddWishlistSingleEvent event, Emitter<SingleProductState> emit) async {
    var index = _productData?.product?.productId == int.parse(event.product_id);
    print('index $index');
    if(index == true){
      var updateProduct = _productData!.product!.copyWith(
          loading: _productData!.product!.loading == true ? false : true
      );
      var updatedProduct = _productData!.copyWith(
          product: updateProduct
      );

      _productData = updatedProduct;
      emit(SingleProductSuccess(_productData!));

      await Api.addWishlistApi(event.product_id).then((value) {
        if(value!.status == 'success'){
          var updateProduct = _productData!.product!.copyWith(
              like: _productData!.product!.like == true ? false : true,
              loading: _productData!.product!.loading = false
          );
          var updatedProduct = _productData!.copyWith(
              product: updateProduct
          );

          _productData = updatedProduct;
          emit(SingleProductSuccess(_productData!));
        }else{
          var updateProduct = _productData!.product!.copyWith(
              cartloading: _productData!.product!.cartloading = false
          );
          var updatedProduct = _productData!.copyWith(
              product: updateProduct
          );

          _productData = updatedProduct;
          emit(SingleProductSuccess(_productData!));
        }
      });
    }
  }

  Future<void> _fetchSingleProduct(SingleProductRefreshEvent event, Emitter<SingleProductState> emit) async {
    /*if(_productData != null){
      print('token: ${Constant.token}');
      final res = await Api.SingleProductApi(event.product_id);
      _productData = res;
      emit(SingleProductSuccess(_productData!));
    }else{*/
    emit(SingleProductLoading());
    SharedPreferences pref = await SharedPreferences.getInstance();
    Constant.token = pref.getString('token').toString();
    try{
      final response = await Api.singleProductApi(event.product_id);
      _productData = response;
      if(response != null){
        emit(SingleProductSuccess(response));
      }else{
        emit(SingleProductError(response!.status.toString()));
      }
    }on SocketException{
      emit(SingleProductError('Please check your internet connection'));
    }catch(e){
      emit(SingleProductError(e.toString()));
    }
    // }
  }
}
