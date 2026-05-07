import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:umkm_store/bloc/current_location/current_location_bloc.dart';
import 'package:umkm_store/bloc/current_location/current_location_state.dart';
import 'package:umkm_store/bloc/customer/customer_bloc.dart';
import 'package:umkm_store/bloc/customer/customer_event.dart';
import 'package:umkm_store/bloc/store_by_category/store_by_category_bloc.dart';
import 'package:umkm_store/bloc/store_by_category/store_by_category_event.dart';
import 'package:umkm_store/bloc/store_by_category/store_by_category_state.dart';
import 'package:umkm_store/model/CategoryModel.dart';
import 'package:umkm_store/model/StoreNearby.dart';
import 'package:umkm_store/services/CustomerService.dart';
import 'package:umkm_store/utils/GlobalColor.dart';
import 'package:umkm_store/widgets/AppBarImage.dart';
import 'package:umkm_store/widgets/card/StoreCard.dart';

class StoreByCategory extends StatelessWidget {
  const StoreByCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final category =
        ModalRoute.of(context)!.settings.arguments as CategoryModel;

    return BlocProvider(
      create: (context) {
        final locationState = context.read<CurrentLocationBloc>().state;
        double? lat, lng;
        if (locationState is CurrentLocationSuccess) {
          lat = locationState.position.latitude;
          lng = locationState.position.longitude;
        }

        return StoreByCategoryBloc(context.read<CustomerService>())
          ..add(FetchStoresByCategory(
            categorySlug: category.name.toLowerCase().replaceAll(" ", "-"),
            latitude: lat,
            longitude: lng,
          ));
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: BlocBuilder<StoreByCategoryBloc, StoreByCategoryState>(
          builder: (context, state) {
            final bool isLoading = state is StoreByCategoryLoading;
            final List<StoreNearby> stores = isLoading
                ? []
                : (state is StoreByCategorySuccess ? state.stores : []);

            return CustomScrollView(
              slivers: [
                _buildAppBar(context, category),
                if (!isLoading && stores.isNotEmpty)
                  _buildResultCount(stores.length),
                _buildStoreList(context, isLoading, stores, category),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, CategoryModel category) {
    return AppBarImage(
      expandedHeight: 150,
      onBackPress: () => Navigator.pop(context),
      title: category.name,
      subtitle: "Temukan UMKM terbaik untuk kategori ini",
    );
  }

  Widget _buildResultCount(int count) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                "$count TOKO DITEMUKAN",
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreList(BuildContext context, bool isLoading,
      List<StoreNearby> stores, CategoryModel category) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      sliver: isLoading || stores.isNotEmpty
          ? Skeletonizer.sliver(
              enabled: isLoading,
              child: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final store = isLoading ? null : stores[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: StoreCard(
                        store: store,
                        onTap: store == null
                            ? () {}
                            : () {
                                context
                                    .read<CustomerBloc>()
                                    .add(SelectStore(store));
                              },
                      ),
                    );
                  },
                  childCount: isLoading ? 5 : stores.length,
                ),
              ),
            )
          : SliverToBoxAdapter(
              child: _buildEmptyState(context, category),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, CategoryModel category) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search, size: 48, color: Colors.grey[300]),
          ),
          const SizedBox(height: 20),
          const Text(
            "UMKM Tidak Ditemukan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Sepertinya belum ada toko di kategori ini.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final locationState = context.read<CurrentLocationBloc>().state;
              double? lat, lng;
              if (locationState is CurrentLocationSuccess) {
                lat = locationState.position.latitude;
                lng = locationState.position.longitude;
              }
              context.read<StoreByCategoryBloc>().add(FetchStoresByCategory(
                    categorySlug:
                        category.name.toLowerCase().replaceAll(" ", "-"),
                    latitude: lat,
                    longitude: lng,
                  ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GlobalColor.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("Coba Segarkan Halaman",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
