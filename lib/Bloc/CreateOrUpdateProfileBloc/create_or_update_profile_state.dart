part of 'create_or_update_profile_bloc.dart';

@immutable
abstract class CreateOrUpdateProfileState {}

class CreateOrUpdateProfileInitial extends CreateOrUpdateProfileState {}
class CreateOrUpdateProfileLoading extends CreateOrUpdateProfileState {}
class CreateOrUpdateProfileSuccess extends CreateOrUpdateProfileState {
  CreateOrUpdateProfileModel createOrUpdateProfileModel;
  CreateOrUpdateProfileSuccess(this.createOrUpdateProfileModel);
}
class CreateOrUpdateProfileError extends CreateOrUpdateProfileState {
  String error;
  CreateOrUpdateProfileError(this.error);
}
