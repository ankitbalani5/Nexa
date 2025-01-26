import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Model/NotificationListModel.dart';

import '../../Api.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationListModel? _productData;
  NotificationBloc() : super(NotificationInitial()) {
    on<GetNotificationEvent>(_getNotification);
    on<DeleteNotificationEvent>(_deleteNotification);
  }

  Future<void> _getNotification(GetNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try{
      final response = await Api.notificationListApi();
      _productData = response;
      if(response != null){
        emit(NotificationSuccess(response));
      }
    }
    on SocketException{
      emit(NotificationError('please check your internet connection'));
    }catch(e){
      emit(NotificationError(e.toString()));

    }
  }

  Future<void> _deleteNotification(DeleteNotificationEvent event, Emitter<NotificationState> emit) async {

    // final response = await Api.notificationDeleteApi(event.notification_id);
    Constant.showDialogProgress(event.context);
    try {
      // Convert list of IDs to a comma-separated string
      String ids = event.notification_id.join(',');

      // Call the API to delete the notifications
      final response = await Api.notificationDeleteApi(ids);

      if (response!.status == 'success') {
        // If the deletion is successful, refresh the notification list
        final notificationUpdate = await Api.notificationListApi();
        emit(NotificationSuccess(notificationUpdate!));
        Navigator.pop(event.context);
      } else {
        emit(NotificationError('Failed to delete notifications'));
      }
    } on SocketException {
      emit(NotificationError('Please check your internet connection'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
