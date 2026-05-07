import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:umkm_store/bloc/category/category_bloc.dart';
import 'package:umkm_store/bloc/category/category_event.dart';
import 'package:umkm_store/bloc/category/category_state.dart';
import 'package:umkm_store/bloc/current_location/current_location_bloc.dart';
import 'package:umkm_store/bloc/current_location/current_location_event.dart';
import 'package:umkm_store/bloc/current_location/current_location_state.dart';
import 'package:umkm_store/bloc/customer/customer_bloc.dart';
import 'package:umkm_store/bloc/customer/customer_event.dart';
import 'package:umkm_store/bloc/customer/customer_state.dart';
import 'package:umkm_store/repository/CategoryRepository.dart';
import 'package:umkm_store/screen/profile/ProfileScreen.dart';
import 'package:umkm_store/screen/promo/PromoScreen.dart';
import 'package:umkm_store/utils/GlobalColor.dart';
import 'package:umkm_store/utils/snackbar_extension.dart';
import 'package:umkm_store/widgets/CategoryGridView.dart';
import 'package:umkm_store/widgets/NearbyStoresList.dart';
import 'package:umkm_store/widgets/SearchAppBar.dart';
import 'package:umkm_store/widgets/bottom_navbar/IconNavbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeBody(),
    const PromoScreen(),
    const ProfileScreen(),
  ];

  Widget _buildGradientIcon(FaIconData icon, bool isActive) {
    return IconNavbar(icon: icon, isActive: isActive);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CategoryBloc(
              categoryRepository: context.read<CategoryRepository>(),
            )..add(FetchCategoryUser()),
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
            BlocListener<CustomerBloc, CustomerState>(
              listener: (context, state) {
                if (state is NavigateToStoreDetail) {
                  Navigator.pushNamed(
                    context,
                    '/store-detail',
                    arguments: state.store,
                  );
                }
              },
            ),
          ],
          child: Scaffold(
            backgroundColor: Colors.white,
            body: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.fromLTRB(24, 0, 24, 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: GlobalColor.primaryColor.withOpacity(0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedItemColor: GlobalColor.blueLightColor,
                  unselectedItemColor: Colors.blueGrey[100],
                  showSelectedLabels: true,
                  showUnselectedLabels: false,
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  items: [
                    BottomNavigationBarItem(
                      icon: _buildGradientIcon(FontAwesomeIcons.house, false),
                      activeIcon:
                          _buildGradientIcon(FontAwesomeIcons.house, true),
                      label: "•",
                    ),
                    BottomNavigationBarItem(
                      icon: _buildGradientIcon(FontAwesomeIcons.ticket, false),
                      activeIcon:
                          _buildGradientIcon(FontAwesomeIcons.ticket, true),
                      label: "•",
                    ),
                    BottomNavigationBarItem(
                      icon: _buildGradientIcon(FontAwesomeIcons.user, false),
                      activeIcon:
                          _buildGradientIcon(FontAwesomeIcons.user, true),
                      label: "•",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomMaterialIndicator(
      onRefresh: () async {
        final categoryBloc = context.read<CategoryBloc>();
        categoryBloc.add(FetchCategoryUser());

        final currentLocationBloc = context.read<CurrentLocationBloc>();
        currentLocationBloc.add(FetchCurrentLocation());

        final locationState = currentLocationBloc.state;
        final customerBloc = context.read<CustomerBloc>();

        if (locationState is CurrentLocationSuccess) {
          customerBloc.add(FetchNearbyStores(
              latitude: locationState.position.latitude,
              longitude: locationState.position.longitude));
        }

        if (locationState is CurrentLocationFailure) {
          context.showErrorSnackBar(locationState.error);
        }

        await Future.wait([
          categoryBloc.stream
              .firstWhere((s) => s is CategoryLoaded || s is CategoryError),
          customerBloc.stream.firstWhere(
              (s) => s is CustomerNearbyStoresSuccess || s is CustomerFailure),
        ]);
      },
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SearchAppBar(),
          SizedBox(
            height: 20,
          ),
          const CategoryGridView(),
          const NearbyStoresList(),
        ],
      ),
    );
  }
}
