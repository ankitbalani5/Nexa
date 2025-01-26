// import 'dart:io';
//
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
//
// import '../../Api.dart';
// import '../../Model/VerifyEmailModel.dart';
//
// part 'verify_password_event.dart';
// part 'verify_password_state.dart';
//
// class VerifyPasswordBloc extends Bloc<VerifyPasswordEvent, VerifyPasswordState> {
//   VerifyPasswordBloc() : super(VerifyPasswordInitial()) {
//     on<VerifyPasswordNewEvent>(_forgotPassword);
//   }
//
//   Future<void> _forgotPassword(VerifyPasswordNewEvent event, Emitter<VerifyPasswordState> emit) async {
//     emit(VerifyPasswordLoading());
//     try{
//       final response = await Api.verifyPasswordApi(event.credentials);
//       if(response!.status == 'success'){
//         emit(VerifyPasswordSuccess(response));
//       }else{
//         emit(VerifyPasswordError(response.message.toString()));
//       }
//     }on SocketException{
//       emit(VerifyPasswordError('Please check your internet connection'));
//     }catch(e){
//       emit(VerifyPasswordError(e.toString()));
//     }
//   }
// }
