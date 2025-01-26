import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Model/AllProductModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api.dart';
import '../../Constant.dart';

part 'all_product_event.dart';
part 'all_product_state.dart';

class AllProductBloc extends Bloc<AllProductEvent, AllProductState> {
  AllProductModel? _productData;
  AllProductBloc() : super(AllProductInitial()) {
    on<AllProductRefreshEvent>(_fetchAllProduct);
    on<SortProductEvent>(_sortAllProduct);
    on<AddWishlistEvent>(_addWishlist);
    on<DataClearEvent>(_handleDataClear);
  }


  Future<void> _addWishlist(AddWishlistEvent event, Emitter<AllProductState> emit) async {
    int index = _productData?.products?.data?.indexWhere((e) => e.id == int.parse(event.product_id)) ?? -1;
    if(index != -1){
      var updateProduct = _productData?.products?.data?[index].copyWith(
        // loading: _productData?.products![index].loading == false ? true : false,
        inWishlist: _productData?.products!.data![index].inWishlist == false ? true : false,
      );
      var myproduct = _productData?.products;
      myproduct!.data![index] = updateProduct!;

      var updatedProductData= _productData!.copyWith(
        products: myproduct
      );
      _productData = updatedProductData;
      emit(AllProductSuccess(_productData!));

      await Api.addWishlistApi(event.product_id.toString()).then((value) {
        if(value?.status == 'success'){

              Fluttertoast.showToast(msg: value!.message.toString(), backgroundColor: Constant.bgOrangeLite);

        }else{
          Fluttertoast.showToast(msg: value!.message.toString(), backgroundColor: Constant.bgRed, textColor: Constant.bgWhite);

        }
      });
    }
  }

  Future<void> _fetchAllProduct(AllProductRefreshEvent event, Emitter<AllProductState> emit) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      Constant.token = pref.getString('token').toString();

      // Emit loading state only on the first load or when explicitly reloading
      if (event.page == 1 && _productData == null) {
        emit(AllProductLoading());
      }

      // Fetch products from API
      final response = await Api.allProductApi(
          event.brand_id,
          event.price_min,
          event.price_max,
          event.rating,
          event.price_ranges,
          event.discount,
          event.page,
          event.top_sale,
          event.price_sorting,
      );

      if (response != null) {
        // Extract the current products from the state if it exists
        List<Data> currentProducts = [];

        if (state is AllProductSuccess) {
          currentProducts = (state as AllProductSuccess).allProductModel.products!.data!;
        }
        final newProducts;
        // Append new products to the current list
        if(event.pagination == false){
          newProducts = [...response.products!.data!];
        }else{
          newProducts = [...currentProducts, ...response.products!.data!];
        }

        // Create a new Products object with the updated product list
        final updatedProducts = response.products!.copyWith(data: newProducts);

        // Update _productData with the new product list
        _productData = response.copyWith(products: updatedProducts);

        // Emit the updated success state with the new product list
        emit(AllProductSuccess(_productData!));
      } else {
        emit(AllProductError('Failed to fetch products'));
      }
    } on SocketException {
      emit(AllProductError('Please check your internet connection'));
    } catch (e) {
      emit(AllProductError(e.toString()));
    }
  }

  Future<void> _sortAllProduct(SortProductEvent event, Emitter<AllProductState> emit) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      Constant.token = pref.getString('token').toString();

      // Emit loading state only on the first load or when explicitly reloading
      if (event.page == 1 && _productData == null) {
        emit(AllProductLoading());
      }
      if(event.filter == true){
        Constant.showDialogProgress(event.context);
      }

      // Fetch products from API
      final response = await Api.sortProductApi(
        event.brand_id,
        event.price_min,
        event.price_max,
        event.rating,
        event.price_ranges,
        event.discount,
        event.page,
        event.top_sale,
        event.price_sorting,
      );

      if (response != null) {
        // Extract the current products from the state if it exists
        List<Data> currentProducts = [];

        if (state is AllProductSuccess) {
          currentProducts = (state as AllProductSuccess).allProductModel.products!.data!;
        }
        final newProducts;
        // Append new products to the current list
        if(event.pagination == false){
          newProducts = [...response.products!.data!];
        }else{
          newProducts = [...currentProducts, ...response.products!.data!];
        }

        // Create a new Products object with the updated product list
        final updatedProducts = response.products!.copyWith(data: newProducts);

        // Update _productData with the new product list
        _productData = response.copyWith(products: updatedProducts);

        // Emit the updated success state with the new product list
        emit(AllProductSuccess(_productData!));
      } else {
        emit(AllProductError('Failed to fetch products'));
      }
    } on SocketException {
      emit(AllProductError('Please check your internet connection'));
    } catch (e) {
      emit(AllProductError(e.toString()));
    }
  }


  void _handleDataClear(DataClearEvent event, Emitter<AllProductState> emit) {
    _productData = null; // Reset the product data
    emit(AllProductInitial()); // Optionally reset to initial state or any other state you prefer
  }

}
