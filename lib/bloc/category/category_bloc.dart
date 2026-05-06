import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/category/category_event.dart';
import 'package:umkm_store/bloc/category/category_state.dart';
import 'package:umkm_store/model/CategoryModel.dart';
import 'package:umkm_store/repository/CategoryRepository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository}) : super(CategoryInitial()) {
    on<FetchCategory>((event, emit) async {
      emit(CategoryLoading());

      try {
        final res = await categoryRepository.getCategories(
            search: event.search, page: event.page);

        if (res.statusCode == 200) {
          List data = res.data['data']['data'];

          List<CategoryModel> items = [];

          for (var e in data) {
            items.add(await CategoryModel.fromJson(e));
          }

          emit(CategoryLoaded(
              items: items,
              currentPage: event.page,
              totalPages: res.data['data']['last_page']));
        } else {
          emit(CategoryError(res.statusMessage.toString()));
        }
      } catch (e) {
        log("e ${e.toString()}");
        emit(CategoryError(e.toString()));
      }
    });

    on<FetchCategoryUser>((event, emit) async {
      emit(CategoryLoading());

      try {
        final res = await categoryRepository.getCategoriesUser();

        if (res.statusCode == 200) {
          List data = res.data['data'];

          List<CategoryModel> items = [];

          for (var e in data) {
            items.add(await CategoryModel.fromJson(e));
          }

          emit(CategoryLoaded(items: items, currentPage: 1, totalPages: 1));
        } else {
          emit(CategoryError(res.statusMessage.toString()));
        }
      } catch (e) {
        log("e ${e.toString()}");
        emit(CategoryError(e.toString()));
      }
    });
  }
}
