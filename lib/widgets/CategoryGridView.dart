import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:umkm_store/bloc/category/category_bloc.dart';
import 'package:umkm_store/bloc/category/category_state.dart';
import 'package:umkm_store/model/CategoryModel.dart';
import 'package:umkm_store/utils/GlobalColor.dart';

class CategoryGridView extends StatelessWidget {
  const CategoryGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                state.error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (state is CategoryLoaded || state is CategoryLoading) {
          final bool isLoading = state is CategoryLoading;

          if (state is CategoryLoaded && state.items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Tidak ada kategori"),
              ),
            );
          }

          return Skeletonizer(
            enabled: isLoading,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.8,
              ),
              itemCount: isLoading ? 8 : (state as CategoryLoaded).items.length,
              itemBuilder: (context, index) {
                final item =
                    isLoading ? null : (state as CategoryLoaded).items[index];
                return _buildCategoryItem(item);
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildCategoryItem(CategoryModel? item) {
    return InkWell(
      onTap: item == null
          ? null
          : () {
              // TODO: Navigate to category products
            },
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: GlobalColor.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: item?.iconUrl != null
                ? Image.network(
                    item!.iconUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.category,
                        color: GlobalColor.dangerColor),
                  )
                : const Icon(Icons.category, color: GlobalColor.primaryColor),
          ),
          const SizedBox(height: 8),
          Text(
            item?.name ?? "Category Name",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: GlobalColor.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
