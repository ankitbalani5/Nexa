import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/Model/ProductReviewModel.dart';

part 'product_review_event.dart';
part 'product_review_state.dart';

class ProductReviewBloc extends Bloc<ProductReviewEvent, ProductReviewState> {
  ProductReviewModel? _productData;
  ProductReviewBloc() : super(ProductReviewInitial()) {
    on<ProductReviewLoadEvent>(_loadReview);
    on<ReviewHelpfulTapEvent>(_helpfulTap);
  }

  Future<void> _loadReview(ProductReviewLoadEvent event, Emitter<ProductReviewState> emit) async {
    emit(ProductReviewLoading());
    try{
      final response = await Api.productReviewApi(event.product_id);
      _productData = response;
      if(response!.status != 'failed'){
        emit(ProductReviewSuccess(response));
      }else{
        emit(ProductReviewInitial());

      }
    }on SocketException{
      emit(ProductReviewError('Please check your internet connection'));
    }catch(e){
      emit(ProductReviewError(e.toString()));
    }
  }

  Future<void> _helpfulTap(ReviewHelpfulTapEvent event, Emitter<ProductReviewState> emit) async {
    // emit(ReviewHelpfulLoading());
    try{
      final response = await Api.reviewHelpfulApi(event.product_id, event.product_review_id);
      if(response!.status == 'success'){
        var index = _productData?.reviews?.indexWhere((e) => e.id == int.parse(event.product_review_id));
        if(index != -1){
          var updateReview = _productData?.reviews![index!].copyWith(
            helpful: _productData?.reviews![index].helpful == false ? true : false,
            helpfulVotesCount: _productData?.reviews![index].helpful == false ? _productData!.reviews![index].helpfulVotesCount! + 1 : _productData!.reviews![index].helpfulVotesCount! - 1
          );
          final reviewList = _productData?.reviews;
          reviewList?[index!] = updateReview!;
          _productData?.copyWith(reviews: reviewList);
          emit(ProductReviewSuccess(_productData!));
        }
      }

    }on SocketException{
      emit(ProductReviewError('Please check your internet connection'));
    }catch(e){
      emit(ProductReviewError(e.toString()));

    }
  }

}
