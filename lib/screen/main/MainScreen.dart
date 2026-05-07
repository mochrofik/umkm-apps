import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/current_location/current_location_bloc.dart';
import 'package:umkm_store/bloc/current_location/current_location_state.dart';
import 'package:umkm_store/bloc/customer/customer_bloc.dart';
import 'package:umkm_store/bloc/customer/customer_event.dart';
import 'package:umkm_store/services/CustomerService.dart';
import 'package:umkm_store/widgets/CategoryGridView.dart';
import 'package:umkm_store/widgets/NearbyStoresList.dart';
import 'package:umkm_store/widgets/SearchAppBar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CustomerBloc(context.read<CustomerService>()),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<CurrentLocationBloc, CurrentLocationState>(
              listener: (context, state) {
                if (state is CurrentLocationSuccess) {
                  context.read<CustomerBloc>().add(FetchNearbyStores(
                        latitude: state.position.latitude,
                        longitude: state.position.longitude,
                      ));
                }
              },
            ),
          ],
          child: Scaffold(
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "UMKM Terdekat dengan lokasimu",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const NearbyStoresList(),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
