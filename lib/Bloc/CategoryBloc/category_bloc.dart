import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Bloc/CategoryWiseProduct/category_wise_product_bloc.dart';
import 'package:nexa/Model/CategoryModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api.dart';
import '../../Constant.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryModel? _productData;
  CategoryBloc() : super(CategoryInitial()) {
    on<CategoryRefreshEvent>(_fetchCategory);
    // on<AddCategoryWishlistEvent>(_addWishlist);
    on<CategoryLogoutEvent>(_handleLogout);
  }

  Future<void> _fetchCategory(CategoryRefreshEvent event, Emitter<CategoryState> emit) async {
    /*if(_productData != null){
      final res = await Api.categoryApi(event.category_name);
      _productData = res;
      emit(CategorySuccess(_productData!));
    }else{*/
      emit(CategoryLoading());
      SharedPreferences pref = await SharedPreferences.getInstance();
      Constant.token = pref.getString('token').toString();
      try{
        final response = await Api.categoryApi();
        _productData = response;
        if(response != null){
          emit(CategorySuccess(response));
        }
      }on SocketException{
        emit(CategoryError('Please check your internet connection'));
      }catch(e){
        emit(CategoryError(e.toString()));
      }
    // }
  }



  // _addWishlist(AddCategoryWishlistEvent event, Emitter<CategoryState> emit) async {
  //   print(_productData!.categories!.indexWhere((category) => category.products!.any((product) => product.id == event.item.id )));
  //
  //   var updatedProductS;
  //   var updatedProductListS;
  //   var updatedSubcategoryS;
  //   var updatedSubcategoryListS;
  //   var updatedCategoriesS;
  //   var updatedCategoryS;
  //
  //   final categoryProductIndex = _productData!.categories!.indexWhere((category) => category.products!.any((product) => product.id == event.item.id));
  //   final categoryIndexS = _productData!.categories!.indexWhere((category) => category.subcategory!.any((subcategory) => subcategory.products!.any((product) => product.id == event.item.id),),);
  //
  //   if (categoryProductIndex != -1 && categoryIndexS != -1) {
  //
  //     final productIndex = _productData?.categories![categoryProductIndex].products!.indexWhere((p) => p.id == event.item.id) ?? 0;
  //     final subcategoryIndexS = _productData!.categories![categoryIndexS].subcategory!.indexWhere((subcategory) => subcategory.products!.any((product) => product.id == event.item.id),);
  //
  //     if (productIndex != -1 && subcategoryIndexS != -1) {
  //       // Find the product within the subcategory
  //       final productIndexS = _productData?.categories![categoryIndexS]
  //           .subcategory![subcategoryIndexS]
  //           .products!
  //           .indexWhere((p) => p.id == event.item.id) ?? -1;
  //
  //       if(productIndexS != -1){
  //         // Toggle loading state for the product
  //         updatedProductS = _productData?.categories![categoryIndexS]
  //             .subcategory![subcategoryIndexS]
  //             .products![productIndexS]
  //             .copyWith(
  //           // loading: !_productData!.categories![categoryIndexS]
  //           //   .subcategory![subcategoryIndexS]
  //           //   .products![productIndexS].loading!,
  //           inWishlist: !_productData!.categories![categoryIndexS]
  //               .subcategory![subcategoryIndexS]
  //               .products![productIndexS].inWishlist!,
  //         );
  //
  //         // Update the subcategory product list
  //         updatedProductListS = List<Products>.from(
  //           _productData!.categories![categoryIndexS].subcategory![subcategoryIndexS].products!,
  //         );
  //         updatedProductListS[productIndexS] = updatedProductS!;
  //
  //         // Update the subcategory
  //         updatedSubcategoryS = _productData!.categories![categoryIndexS]
  //             .subcategory![subcategoryIndexS]
  //             .copyWith(products: updatedProductListS);
  //
  //         // Update the subcategory list in the category
  //         updatedSubcategoryListS = List<Subcategory>.from(
  //           _productData!.categories![categoryIndexS].subcategory!,
  //         );
  //         updatedSubcategoryListS[subcategoryIndexS] = updatedSubcategoryS!;
  //
  //         // Update the category
  //         updatedCategoryS = _productData!.categories![categoryIndexS]
  //             .copyWith(subcategory: updatedSubcategoryListS);
  //
  //         // Update the categories list
  //         updatedCategoriesS = List<Categories>.from(_productData!.categories!);
  //         updatedCategoriesS[categoryIndexS] = updatedCategoryS!;
  //
  //         // Update the entire product data
  //         _productData = _productData?.copyWith(categories: updatedCategoriesS);
  //       }
  //
  //       // Toggle loading state
  //       final updatedProduct = _productData?.categories![categoryProductIndex].products![productIndex].copyWith(
  //           inWishlist: _productData?.categories![categoryProductIndex].products![productIndex].inWishlist! == true ? false : true,
  //           // loading: _productData?.categories![categoryProductIndex].products![productIndex].loading! == false ? true : false
  //       );
  //
  //       // Update the product list
  //       final updatedProductList = List<Products>.from(_productData?.categories![categoryProductIndex].products ?? []);
  //       updatedProductList[productIndex] = updatedProduct!;
  //
  //       // Update the category
  //       final updatedCategory = _productData?.categories![categoryProductIndex].copyWith(products: updatedProductList);
  //
  //       // Update categories list
  //       final updatedCategories = List<Categories>.from(_productData?.categories ?? []);
  //       updatedCategories[categoryProductIndex] = updatedCategory!;
  //
  //       // Update the entire product data
  //       final updatedProductData = _productData?.copyWith(
  //         categories: updatedCategories,
  //       );
  //       _productData = updatedProductData;
  //       emit(CategorySuccess(_productData!));
  //
  //       // Call the API
  //       await Api.addWishlistApi(event.item.id.toString()).then((value) {
  //         if (value?.status == 'success') {
  //
  //         } else {
  //           Fluttertoast.showToast(msg: value!.message.toString());
  //         }
  //       }).catchError((error) {
  //         print(error);
  //       });
  //     }
  //   }
  // }


  void _handleLogout(CategoryLogoutEvent event, Emitter<CategoryState> emit) {
    _productData = null; // Reset the product data
    emit(CategoryInitial()); // Optionally reset to initial state or any other state you prefer
  }

}
