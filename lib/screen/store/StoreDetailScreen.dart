import 'package:flutter/material.dart';
import 'package:umkm_store/model/StoreNearby.dart';
import 'package:umkm_store/utils/GlobalColor.dart';

class StoreDetailScreen extends StatelessWidget {
  const StoreDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan argument store yang dikirim dari navigator
    final store = ModalRoute.of(context)!.settings.arguments as StoreNearby;

    return Scaffold(
      appBar: AppBar(
        title: Text(store.name),
        backgroundColor: Colors.white,
        foregroundColor: GlobalColor.textDark,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image / Logo
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: store.logoUrl != null
                  ? Image.network(store.logoUrl!, fit: BoxFit.cover)
                  : const Icon(Icons.storefront, size: 100, color: Colors.grey),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          store.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: GlobalColor.textDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.orange, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              store.rating.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16, color: GlobalColor.primaryColor),
                      const SizedBox(width: 5),
                      Text(
                        store.formattedJarak,
                        style: TextStyle(
                          color: GlobalColor.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Tentang UMKM",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: GlobalColor.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    store.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Action: Belanja atau Hubungi
                      },
                      child: const Text("HUBUNGI TOKO"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
