import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/login/login_bloc.dart';
import 'package:umkm_store/bloc/register/register_bloc.dart';
import 'package:umkm_store/bloc/splash_bloc.dart';
import 'package:umkm_store/bloc/splash_event.dart';
import 'package:umkm_store/screen/category/category.dart';
import 'package:umkm_store/screen/home/home.dart';
import 'package:umkm_store/screen/login/login.dart';
import 'package:umkm_store/screen/main/MainScreen.dart';
import 'package:umkm_store/screen/splashscreen/splashscreen.dart';
import 'package:umkm_store/services/AuthRepository.dart';
import 'package:umkm_store/services/StorageService.dart';
import 'package:umkm_store/utils/GlobalColor.dart';

import 'package:umkm_store/repository/CategoryRepository.dart';
import 'package:umkm_store/bloc/category/category_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(create: (context) => StorageService()),
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => CategoryRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => SplashBloc(
                    context.read<StorageService>(),
                  )..add(StartAppCheck())),
          BlocProvider(
              create: (context) =>
                  LoginBloc(authRepository: context.read<AuthRepository>())),
          BlocProvider(create: (context) => RegisterBloc()),
          BlocProvider(
              create: (context) => CategoryBloc(
                  categoryRepository: context.read<CategoryRepository>()))
        ],
        child: MaterialApp(
          theme: ThemeData(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColor.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
            primaryColor: GlobalColor.primaryColor,
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => const SplashScreen(),
            '/main-screen': (context) => const MainScreen(),
            '/login': (context) => const LoginPage(),
            '/home': (context) => const HomePage(),
            '/master-kategori': (context) => const MasterKategoriPage(),
          },
        ),
      ),
    );
  }
}
