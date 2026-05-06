import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/category/category_bloc.dart';
import 'package:umkm_store/bloc/category/category_event.dart';
import 'package:umkm_store/bloc/category/category_state.dart';
import 'package:umkm_store/repository/CategoryRepository.dart';

import '../../utils/GlobalColor.dart';

class MasterKategoriPage extends StatelessWidget {
  const MasterKategoriPage({super.key});

  @override
  Widget build(BuildContext context) {
    log("build ");
    return BlocProvider(
      create: (context) =>
          CategoryBloc(categoryRepository: CategoryRepository())
            ..add(FetchCategory()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text("Master Kategori",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: GlobalColor.textDark)),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: GlobalColor.textDark),
        ),
        body: Column(
          children: [
            // --- HEADER: SEARCH & ADD ---
            _buildTopActions(context),

            //---List Data ----
            _buildListData(context),

            _buildPaginationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopActions(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, snapshot) {
      log("build cari");
      return Container(
        padding: const EdgeInsets.all(15),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onSubmitted: (val) =>
                    context.read<CategoryBloc>().add(FetchCategory(
                          search: val,
                        )),
                decoration: InputDecoration(
                  hintText: "Cari kategori...",
                  hintStyle: const TextStyle(color: GlobalColor.greyHint),
                  prefixIcon:
                      const Icon(Icons.search, color: GlobalColor.primaryColor),
                  filled: true,
                  fillColor: const Color(0xFFF1F3F4),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                showAddCategoryModal(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColor.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                elevation: 0,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      );
    });
  }

  void showAddCategoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Agar modal bisa naik saat keyboard muncul
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Padding keyboard
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Preview Gambar
              GestureDetector(
                onTap: () async {},
                child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      image: null,
                    ),
                    child: Icon(Icons.add_a_photo)),
              ),

              TextField(
                decoration: InputDecoration(labelText: 'Nama Kategori'),
                onChanged: null,
              ),

              ElevatedButton(
                onPressed: null,
                child: Text("Simpan"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListData(BuildContext context) {
    return Expanded(child:
        BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      if (state is CategoryLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is CategoryLoaded) {
        if (state.items.isEmpty) {
          return const Center(
            child: Text("Data tidak ditemukan!"),
          );
        } else {
          return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: GlobalColor.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: state.items[index].iconUrl != null
                            ? Image.network(
                                state.items[index].iconUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.category_rounded,
                                        color: GlobalColor.dangerColor),
                              )
                            : const Icon(Icons.category_rounded,
                                color: GlobalColor.primaryColor),
                      ),
                    ),
                    title: Text(state.items[index].name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: GlobalColor.textDark)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: GlobalColor.warningColor),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: GlobalColor.dangerColor),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
      }

      return const Center(
        child: Text("Data tidak ditemukan"),
      );
    }));
  }

  Widget _buildPaginationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child:
          BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
        if (state is CategoryLoaded) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Hal ${state.currentPage} dari ${state.totalPages}",
                  style: const TextStyle(
                      color: GlobalColor.greyHint, fontSize: 13)),
              Row(
                children: [
                  _pageButton(
                    icon: Icons.chevron_left,
                    isEnabled: state.currentPage == 1 ? false : true,
                    onTap: () => context.read<CategoryBloc>().add(
                        FetchCategory(search: "", page: state.currentPage - 1)),
                  ),
                  const SizedBox(width: 8),
                  _pageButton(
                    icon: Icons.chevron_right,
                    isEnabled:
                        state.currentPage < state.totalPages ? true : false,
                    onTap: () => context.read<CategoryBloc>().add(
                        FetchCategory(search: "", page: state.currentPage + 1)),
                  ),
                ],
              )
            ],
          );
        }

        return const SizedBox();
      }),
    );
  }

  Widget _pageButton(
      {required IconData icon,
      required bool isEnabled,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isEnabled
              ? GlobalColor.primaryColor.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            color: isEnabled ? GlobalColor.primaryColor : GlobalColor.greyHint,
            size: 20),
      ),
    );
  }
}
