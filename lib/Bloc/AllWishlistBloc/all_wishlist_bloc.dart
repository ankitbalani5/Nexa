import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Bloc/HomeBloc/home_bloc.dart';
import 'package:nexa/Model/AllWishlistModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api.dart';
import '../../Constant.dart';

part 'all_wishlist_event.dart';
part 'all_wishlist_state.dart';

class AllWishlistBloc extends Bloc<AllWishlistEvent, AllWishlistState> {
  AllWishlistModel? _productData;
  AllWishlistBloc() : super(AllWishlistInitial()) {
    on<WishlistRefreshEvent>(_fetchWishlist);
    on<AddToCartWishlistEvent>(_addToCartWishlist);
    on<RemoveWishlistEvent>(_removeWishlist);
    on<WishlistLogoutEvent>(_handleLogout);
  }

  Future<void> _fetchWishlist(WishlistRefreshEvent event, Emitter<AllWishlistState> emit) async {
    if(_productData != null){
      final res = await Api.allWishlistApi();
      _productData = res;
      emit(AllWishlistSuccess(_productData!));
    }else{
      emit(AllWishlistLoading());
      SharedPreferences pref = await SharedPreferences.getInstance();
      Constant.token = pref.getString('token').toString();
      try{
        final response = await Api.allWishlistApi();
        _productData = response;
        if(response != null){
          emit(AllWishlistSuccess(response));
        }
      }on SocketException{
        emit(AllWishlistError('Please check your internet connection'));
      }catch(e){
        emit(AllWishlistError(e.toString()));
      }
    }

  }

  Future<void> _addToCartWishlist(AddToCartWishlistEvent event, Emitter<AllWishlistState> emit) async {
    var index = _productData!.wishlistProducts!.indexWhere((e) => e.id == event.item.id);

    if (index != -1) {
      // Retrieve the current wishlist product and set loadingcart to true
      final currentProduct = _productData?.wishlistProducts?[index];
      if (currentProduct != null) {
        final updatedProduct = currentProduct.copyWith(
            loadingcart: _productData!.wishlistProducts?[index].loadingcart == false ? true : false
        );


        final updatedWishlist = _productData!.wishlistProducts;
        updatedWishlist![index] = updatedProduct;
        final allUpdatedData = _productData!.copyWith(
          wishlistProducts: updatedWishlist
        );
        _productData = allUpdatedData;

        // Emit the state with loadingcart set to true
        emit(AllWishlistSuccess(_productData!));

        try {
          var price = event.item.salePrice == null || event.item.salePrice == 'null'
              ? event.item.regularPrice.toString()
              : event.item.salePrice.toString();
          print('price:: ${price}');
          // Make the API call to add the product to the cart
          await Api.addToCartApi(event.item.id.toString(), '1', price).then((value) {
            if(value!.status == 'success'){
              final updatedProduct = currentProduct.copyWith(
                  loadingcart: _productData!.wishlistProducts?[index].loadingcart = false
              );

              final updatedWishlist = _productData!.wishlistProducts;
              updatedWishlist![index] = updatedProduct;
              final allUpdatedData = _productData!.copyWith(
                  wishlistProducts: updatedWishlist
              );
              _productData = allUpdatedData;

              // Emit the state with loadingcart set to true
              emit(AllWishlistSuccess(_productData!));
              Fluttertoast.showToast(msg: value.message.toString(), backgroundColor: Constant.bgOrangeLite);

            }
            else{
              final updatedProduct = currentProduct.copyWith(
                  loadingcart: _productData!.wishlistProducts?[index].loadingcart = false
              );

              final updatedWishlist = _productData!.wishlistProducts;
              updatedWishlist![index] = updatedProduct;
              final allUpdatedData = _productData!.copyWith(
                  wishlistProducts: updatedWishlist
              );
              _productData = allUpdatedData;

              // Emit the state with loadingcart set to true
              emit(AllWishlistSuccess(_productData!));
              Fluttertoast.showToast(msg: value.message.toString(), backgroundColor: Constant.bgOrangeLite);

            }
          });

        } catch (e, stacktrace) {
          print('Caught error: $e');
          print('Stacktrace: $stacktrace');
        }
      }
    }
  }

  Future<void> _removeWishlist(RemoveWishlistEvent event, Emitter<AllWishlistState> emit) async {
    final index = _productData!.wishlistProducts!.indexWhere((e) => e.id == event.item.id);
  if(index != null && index != -1){/*
    final updateData = _productData!.wishlistProducts![index].copyWith(
      loadinglike: _productData!.wishlistProducts![index].loadinglike == false ? true : false
    );
    final updatedData = _productData!.wishlistProducts;
    updatedData![index] = updateData;
    final allUpdateData = _productData!.copyWith(
      wishlistProducts: updatedData
    );
    _productData = allUpdateData;
    emit(AllWishlistSuccess(_productData!));*/

    _productData?.wishlistProducts?.removeAt(index);
    emit(AllWishlistSuccess(_productData!));

    try {
      await Api.addWishlistApi(event.item.id.toString()).then((value) {
        if(value!.status == 'success'){
          // _productData?.wishlistProducts?.removeAt(index);
          // emit(AllWishlistSuccess(_productData!));
        }
      }); // Example API call to delete item
    } catch (e) {
      emit(AllWishlistError(e.toString()));
    }
  }
  }

  void _handleLogout(WishlistLogoutEvent event, Emitter<AllWishlistState> emit) {
    _productData = null; // Reset the product data
    emit(AllWishlistInitial()); // Optionally reset to initial state or any other state you prefer
  }


}
