import 'dart:async';
import 'dart:io' as io;

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Model/CreateOrUpdateProfileModel.dart';

import '../../Api.dart';

part 'create_or_update_profile_event.dart';
part 'create_or_update_profile_state.dart';

class CreateOrUpdateProfileBloc extends Bloc<CreateOrUpdateProfileEvent, CreateOrUpdateProfileState> {
  CreateOrUpdateProfileBloc() : super(CreateOrUpdateProfileInitial()) {
    on<CreateOrUpdateProfileRefreshEvent>(_createOrUpdateProfile);
  }

  Future<void> _createOrUpdateProfile(CreateOrUpdateProfileRefreshEvent event, Emitter<CreateOrUpdateProfileState> emit) async {
    emit(CreateOrUpdateProfileLoading());
    try{
      final response = await Api.createOrUpdateProfileApi(event.first_name, event.last_name,
          event.country,
          event.country_code,
          event.phone,
          event.password, event.image,
          event.email);
      if(response!.status == 'success'){
        emit(CreateOrUpdateProfileSuccess(response));
      }else{
        emit(CreateOrUpdateProfileError(response.message.toString()));
      }
    }on io.SocketException{
      emit(CreateOrUpdateProfileError('Please check your internet connection'));
    }catch(e){
      emit(CreateOrUpdateProfileError(e.toString()));
    }
  }
}
