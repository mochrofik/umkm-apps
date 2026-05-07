import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:umkm_store/bloc/login/login_bloc.dart';
import 'package:umkm_store/bloc/register/register_bloc.dart';
import 'package:umkm_store/bloc/splash_bloc.dart';
import 'package:umkm_store/bloc/splash_event.dart';
import 'package:umkm_store/screen/category/category.dart';
import 'package:umkm_store/screen/home/home.dart';
import 'package:umkm_store/screen/login/login.dart';
import 'package:umkm_store/screen/main/MainScreen.dart';
import 'package:umkm_store/screen/register/register.dart';
import 'package:umkm_store/screen/splashscreen/splashscreen.dart';
import 'package:umkm_store/screen/store/StoreDetailScreen.dart';
import 'package:umkm_store/services/AuthRepository.dart';
import 'package:umkm_store/services/AuthService.dart';
import 'package:umkm_store/services/CustomerService.dart';
import 'package:umkm_store/repository/CustomerRepository.dart';
import 'package:umkm_store/services/CurrentLocationService.dart';
import 'package:umkm_store/services/RegisterService.dart';
import 'package:umkm_store/services/StorageService.dart';
import 'package:umkm_store/utils/GlobalColor.dart';

import 'package:umkm_store/repository/CategoryRepository.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // We're using the manual installation on non-web platforms since Google sign in plugin doesn't yet support Dart initialization.
  // See related issue: https://github.com/flutter/flutter/issues/96391
  await dotenv.load();
  // We store the app and auth to make testing with a named instance easier.
  app = await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: dotenv.env['API_KEY']!,
          appId: dotenv.env['APP_ID']!,
          messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
          projectId: dotenv.env['PROJECT_ID']!));
  auth = FirebaseAuth.instanceFor(app: app);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(create: (context) => Logger()),
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => CategoryRepository()),
        RepositoryProvider(create: (context) => CustomerRepository()),
        RepositoryProvider(create: (context) => StorageService()),
        RepositoryProvider(create: (context) => AuthService()),
        RepositoryProvider(create: (context) => RegisterService()),
        RepositoryProvider(create: (context) => CurrentLocationService()),
        RepositoryProvider(
            create: (context) => CustomerService(
                  context.read<CustomerRepository>(),
                  context.read<Logger>(),
                )),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => SplashBloc(
                    context.read<StorageService>(),
                  )..add(StartAppCheck())),
          BlocProvider(
              create: (context) => LoginBloc(
                    storageService: context.read<StorageService>(),
                    authService: context.read<AuthService>(),
                  )),
          BlocProvider(
              create: (context) =>
                  RegisterBloc(context.read<RegisterService>())),
        ],
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: GlobalColor.primaryColor,
              primary: GlobalColor.primaryColor,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColor.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => const SplashScreen(),
            '/register': (context) => const RegisterScreen(),
            '/main-screen': (context) => const MainScreen(),
            '/login': (context) => const LoginPage(),
            '/home': (context) => const HomePage(),
            '/master-kategori': (context) => const MasterKategoriPage(),
            '/store-detail': (context) => const StoreDetailScreen(),
          },
        ),
      ),
    );
  }
}
