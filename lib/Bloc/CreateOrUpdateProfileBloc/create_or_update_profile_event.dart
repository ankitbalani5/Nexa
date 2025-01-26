part of 'create_or_update_profile_bloc.dart';

@immutable
abstract class CreateOrUpdateProfileEvent {}
class CreateOrUpdateProfileRefreshEvent extends CreateOrUpdateProfileEvent {
  String first_name;
  String last_name;
  String country;
  String country_code;
  String phone;
  String password;
  io.File? image;
  String email;
  CreateOrUpdateProfileRefreshEvent(this.first_name, this.last_name,
      this.country, this.country_code, this.phone, this.password,
      this.image, this.email);
}
