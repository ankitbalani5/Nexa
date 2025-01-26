import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/Model/SubCategoryModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constant.dart';

part 'sub_category_event.dart';
part 'sub_category_state.dart';

class SubCategoryBloc extends Bloc<SubCategoryEvent, SubCategoryState> {
  SubCategoryModel? _productData;
  SubCategoryBloc() : super(SubCategoryInitial()) {
    on<SubCategoryLoadEvent>(_subCategoryLoad);
    on<AddWishlistEvent>(_addWishlist);
    on<DataClearEvent>(_handleDataClear);
  }

  Future<void> _subCategoryLoad(SubCategoryLoadEvent event, Emitter<SubCategoryState> emit) async {
    // emit(SubCategoryLoading());
    try{
      SharedPreferences pref = await SharedPreferences.getInstance();
      Constant.token = pref.getString('token').toString();
// when pagination
      if(event.pagination == true){
        // Emit loading state only on the first load or when explicitly reloading
        if (event.page == 1 && _productData == null) {
          emit(SubCategoryLoading());
        }
        final response = await Api.subCategoryApi(event.category_id, event.sub_cat_id, event.page.toString(), event.search_keyword);
        if (response != null) {
          // Extract the current products from the state if it exists
          List<Data> currentProducts = [];

          if (state is SubCategorySuccess) {
            currentProducts = (state as SubCategorySuccess).subCategoryModel.products!.data!;
          }

          // Append new products to the current list
          final newProducts = [...currentProducts, ...response.products!.data!];
          // var updateProducts = response.copyWith(products: response.products);

          // Create a new Products object with the updated product list
          final updatedProducts = response.products!.copyWith(data: newProducts);

          // Update _productData with the new product list
          _productData = response.copyWith(products: updatedProducts);

          // Emit the updated success state with the new product list
          emit(SubCategorySuccess(_productData!));
        } else {
          emit(SubCategoryError('Failed to fetch products'));
        }
      }
// when search
      else{
        // Emit loading state only on the first load or when explicitly reloading
        // if (event.page == 1 && _productData == null) {
          emit(SubCategoryLoading());
        // }
        final response = await Api.subCategoryApi(event.category_id, event.sub_cat_id, event.page.toString(), event.search_keyword);
        if (response != null) {
          // Extract the current products from the state if it exists
          List<Data> currentProducts = [];

          if (state is SubCategorySuccess) {
            currentProducts = (state as SubCategorySuccess).subCategoryModel.products!.data!;
          }

          // Append new products to the current list
          final newProducts = [...currentProducts, ...response.products!.data!];

          var updateProducts = response.copyWith(products: response.products);

          // Create a new Products object with the updated product list
          final updatedProducts = response.products!.copyWith(data: newProducts, currentPage: response.products?.currentPage);

          // Update _productData with the new product list
          _productData = response.copyWith(products: updatedProducts);

          // Emit the updated success state with the new product list
          emit(SubCategorySuccess(_productData!));
        } else {
          emit(SubCategoryError('Failed to fetch products'));
        }
      }


    }on SocketException{
      emit(SubCategoryError('Please check your internet connection'));
    }catch(e){
      emit(SubCategoryError(e.toString()));
    }
  }

  Future<void> _addWishlist(AddWishlistEvent event, Emitter<SubCategoryState> emit) async {
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
      emit(SubCategorySuccess(_productData!));

      await Api.addWishlistApi(event.product_id.toString()).then((value) {
        if(value?.status == 'success'){

          Fluttertoast.showToast(msg: value!.message.toString(), backgroundColor: Constant.bgOrangeLite);

        }else{
          Fluttertoast.showToast(msg: value!.message.toString(), backgroundColor: Constant.bgRed, textColor: Constant.bgWhite);

        }
      });
    }
  }

  void _handleDataClear(DataClearEvent event, Emitter<SubCategoryState> emit) {
    _productData = null; // Reset the product data
    emit(SubCategoryInitial()); // Optionally reset to initial state or any other state you prefer
  }
}
