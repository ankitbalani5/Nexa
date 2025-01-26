part of 'sub_category_bloc.dart';

@immutable
sealed class SubCategoryState {}

final class SubCategoryInitial extends SubCategoryState {}
final class SubCategoryLoading extends SubCategoryState {}
final class SubCategorySuccess extends SubCategoryState {
  SubCategoryModel subCategoryModel;
  SubCategorySuccess(this.subCategoryModel);
}
final class SubCategoryError extends SubCategoryState {
  String error;
  SubCategoryError(this.error);
}
