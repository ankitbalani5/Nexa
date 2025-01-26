import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/Model/ReviewHelpfulModel.dart';

part 'review_helpful_event.dart';
part 'review_helpful_state.dart';

class ReviewHelpfulBloc extends Bloc<ReviewHelpfulEvent, ReviewHelpfulState> {
  ReviewHelpfulBloc() : super(ReviewHelpfulInitial()) {
    on<ReviewHelpfulTapEvent>(_helpfulTap);
  }

  Future<void> _helpfulTap(ReviewHelpfulTapEvent event, Emitter<ReviewHelpfulState> emit) async {
    emit(ReviewHelpfulLoading());
    try{
      final response = await Api.reviewHelpfulApi(event.product_id, event.product_review_id);
      if(response!.status == 'success'){
        emit(ReviewHelpfulSuccess(response));
      }

    }on SocketException{
      emit(ReviewHelpfulError('Please check your internet connection'));
    }catch(e){
      emit(ReviewHelpfulError(e.toString()));

    }
  }
}
