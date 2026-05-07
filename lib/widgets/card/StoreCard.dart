import 'package:flutter/material.dart';
import 'package:umkm_store/model/StoreNearby.dart';
import 'package:umkm_store/utils/GlobalColor.dart';

class StoreCard extends StatelessWidget {
  final StoreNearby? store;
  final VoidCallback onTap;
  const StoreCard({super.key, this.store, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
            child: store != null && store!.logoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(store!.logoUrl!, fit: BoxFit.cover),
                  )
                : Icon(Icons.storefront,
                    color: GlobalColor.primaryColor, size: 30),
          ),
          title: Text(
            store?.name ?? "Nama toko sedang di muat",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                store?.description ?? "deskripsi toko sedang dimuat",
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
                    store?.formattedJarak ?? "jarak",
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
                    store?.rating.toString() ?? "rating",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
