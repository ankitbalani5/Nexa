part of 'category_bloc.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}
final class CategoryLoading extends CategoryState {}
final class CategorySuccess extends CategoryState {
  CategoryModel categoryModel;
  CategorySuccess(this.categoryModel);
}
final class CategoryError extends CategoryState {
  String error;
  CategoryError(this.error);
}
