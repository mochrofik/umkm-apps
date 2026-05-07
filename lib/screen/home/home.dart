import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/home/home_bloc.dart';
import 'package:umkm_store/bloc/home/home_event.dart';
import 'package:umkm_store/bloc/home/home_state.dart';
import 'package:umkm_store/bloc/login/login_bloc.dart';
import 'package:umkm_store/bloc/login/login_event.dart';
import 'package:umkm_store/bloc/login/login_state.dart';
import 'package:umkm_store/model/UserModel.dart';
import 'package:umkm_store/utils/GlobalColor.dart';
import 'package:umkm_store/widgets/button/PrimaryButton.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeData()),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginInitial) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Berhasil logout!"),
                  backgroundColor: Colors.green),
            );
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is HomeLoaded) {
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      _buildModernHeader(state.user),
                      _buildUserProfileCard(state.user),
                      _buildMenuSection(context),
                      _buildLogout()
                    ],
                  );
                }

                // Tampilan jika Sesi Berakhir / Data tidak dimuat
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_clock_rounded,
                          size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        "Sesi Anda telah berakhir",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text("Silahkan masuk kembali untuk melanjutkan"),
                      const SizedBox(height: 24),
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return PrimaryButton(
                            onPressed: () {
                              context.read<LoginBloc>().add(LogoutRequested());
                            },
                            text: "LOGOUT & MASUK ULANG",
                            isLoading: state is LoginLoading,
                          );
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogout() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
      sliver: SliverToBoxAdapter(
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: state is LoginLoading
                    ? null
                    : () {
                        context.read<LoginBloc>().add(LogoutRequested());
                      },
                icon: state is LoginLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.red),
                      )
                    : const Icon(Icons.logout_rounded),
                label: const Text("LOGOUT DARI APLIKASI"),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModernHeader(UserData user) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Panel ${user.role.toUpperCase()}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: GlobalColor.primaryColor,
                    letterSpacing: 1.2,
                  ),
                ),
                const Text(
                  "Dashboard UMKM",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: GlobalColor.textDark,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 10),
                ],
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.notifications_none_rounded,
                    color: GlobalColor.textDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER: STATS CARD ---
  Widget _buildUserProfileCard(UserData user) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [GlobalColor.primaryColor, GlobalColor.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: GlobalColor.primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: GlobalColor.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Info User
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Badge Role
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        user.role,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER: MENU LIST ---
  Widget _buildMenuSection(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Manajemen Data",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: GlobalColor.textDark,
              ),
            ),
            const SizedBox(height: 16),
            _menuTile(
              context,
              title: "Master Kategori",
              desc: "Atur pengelompokan data kategori",
              icon: Icons.grid_view_rounded,
              iconColor: GlobalColor.primaryColor,
              onTap: () => Navigator.pushNamed(context, '/master-kategori'),
            ),
            const SizedBox(height: 12),
            _menuTile(
              context,
              title: "Data Toko",
              desc: "Kelola informasi detail mitra toko",
              icon: Icons.storefront_rounded,
              iconColor: GlobalColor.orangeColor,
              onTap: () => Navigator.pushNamed(context, '/data-toko'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(BuildContext context,
      {required String title,
      required String desc,
      required IconData icon,
      required Color iconColor,
      required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: GlobalColor.textDark),
        ),
        subtitle: Text(
          desc,
          style: const TextStyle(color: GlobalColor.greyHint, fontSize: 13),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: GlobalColor.greyHint),
      ),
    );
  }
}
