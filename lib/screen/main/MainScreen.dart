import 'package:flutter/material.dart';
import 'package:umkm_store/widgets/CategoryGridView.dart';
import 'package:umkm_store/widgets/SearchAppBar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SearchAppBar(),
          const CategoryGridView(),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    "UMKM Terdekat dengan lokasimu",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
