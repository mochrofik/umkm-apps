import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/customer/customer_bloc.dart';
import 'package:umkm_store/bloc/customer/customer_state.dart';
import 'package:umkm_store/model/StoreNearby.dart';
import 'package:umkm_store/utils/GlobalColor.dart';

class NearbyStoresList extends StatelessWidget {
  const NearbyStoresList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state is CustomerLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is CustomerNearbyStoresSuccess) {
          final stores = state.stores;

          if (stores.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text("Tidak ada UMKM di sekitar Anda"),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: stores.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final store = stores[index];
              return _buildStoreCard(store);
            },
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

  Widget _buildStoreCard(StoreNearby store) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: store.logoUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(store.logoUrl!, fit: BoxFit.cover),
                )
              : Icon(Icons.storefront,
                  color: GlobalColor.primaryColor, size: 30),
        ),
        title: Text(
          store.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              store.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on,
                    size: 14, color: GlobalColor.primaryColor),
                const SizedBox(width: 4),
                Text(
                  store.formattedJarak,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: GlobalColor.primaryColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.star, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  store.rating.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
