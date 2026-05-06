import 'package:equatable/equatable.dart';
import 'package:umkm_store/model/CategoryModel.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> items;
  final int currentPage;
  final int totalPages;
  final String currentQuery;

  CategoryLoaded({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    this.currentQuery = '',
  });

  @override
  List<Object?> get props => [items, currentPage, totalPages, currentQuery];
}

class CategoryError extends CategoryState {
  final String error;
  CategoryError(this.error);
}
