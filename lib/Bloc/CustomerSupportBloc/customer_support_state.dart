part of 'customer_support_bloc.dart';

@immutable
abstract class CustomerSupportState {}

class CustomerSupportInitial extends CustomerSupportState {}
class CustomerSupportLoading extends CustomerSupportState {}
class CustomerSupportSuccess extends CustomerSupportState {
  CustomerSupportModel customerSupportModel;
  CustomerSupportSuccess(this.customerSupportModel);
}
class CustomerSupportError extends CustomerSupportState {
  String error;
  CustomerSupportError(this.error);
}
