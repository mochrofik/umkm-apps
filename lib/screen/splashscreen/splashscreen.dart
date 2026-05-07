import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/splash_bloc.dart';
import 'package:umkm_store/bloc/splash_state.dart';
import 'package:umkm_store/utils/GlobalColor.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        log(state.toString());
        if (state is SplashAuthenticated) {
          if (state.user.roles.contains('customer')) {
            Navigator.pushReplacementNamed(context, '/main-screen');
          } else if (state.user.roles.contains('admin')) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else if (state is SplashUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        backgroundColor: GlobalColor.primaryColor,
        body: Center(
          child: Image.asset(
            'assets/images/le_melleh.png',
            width: 200, // Ukuran "pas" di tengah
          ),
        ),
      ),
    );
  }
}
