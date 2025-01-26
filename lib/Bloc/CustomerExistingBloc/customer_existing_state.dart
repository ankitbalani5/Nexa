part of 'customer_existing_bloc.dart';

@immutable
abstract class CustomerExistingState {}

class CustomerExistingInitial extends CustomerExistingState {}
class CustomerExistingLoading extends CustomerExistingState {}
class CustomerExistingSuccess extends CustomerExistingState {
  CustomerExistingModel customerExistingModel;
  CustomerExistingSuccess(this.customerExistingModel);
}
class CustomerExistingError extends CustomerExistingState {
  String error;
  CustomerExistingError(this.error);
}
