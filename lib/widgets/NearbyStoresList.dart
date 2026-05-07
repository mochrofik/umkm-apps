import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:umkm_store/bloc/customer/customer_bloc.dart';
import 'package:umkm_store/bloc/customer/customer_event.dart';
import 'package:umkm_store/bloc/customer/customer_state.dart';
import 'package:umkm_store/model/StoreNearby.dart';
import 'package:umkm_store/widgets/card/StoreCard.dart';

class NearbyStoresList extends StatelessWidget {
  const NearbyStoresList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state is CustomerNearbyStoresSuccess || state is CustomerLoading) {
          final bool isLoading = state is CustomerLoading;
          final stores = isLoading
              ? []
              : state is CustomerNearbyStoresSuccess
                  ? state.stores
                  : [];

          if (state is CustomerNearbyStoresSuccess && stores.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text("Tidak ada UMKM di sekitar Anda"),
              ),
            );
          }

          return Skeletonizer(
            enabled: isLoading,
            child: Column(
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "UMKM Terdekat dengan lokasimu",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: isLoading ? 4 : stores.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final store = isLoading ? null : stores[index];
                    return _buildStoreCard(context, store);
                  },
                ),
              ],
            ),
          );
        }

        if (state is CustomerFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                "Gagal memuat data: ${state.error}",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        return SizedBox();
      },
    );
  }

  Widget _buildStoreCard(BuildContext context, StoreNearby? store) {
    return StoreCard(
        store: store,
        onTap: store == null
            ? () => {}
            : () => context.read<CustomerBloc>().add(SelectStore(store)));
  }
}
