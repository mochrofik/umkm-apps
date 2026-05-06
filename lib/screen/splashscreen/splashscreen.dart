import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/splash_bloc.dart';
import 'package:umkm_store/bloc/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is SplashUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        backgroundColor:
            Colors.blue, // Gunakan Global Color yang kita bahas tadi
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "UMKM Store",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(height: 20),
              BlocBuilder<SplashBloc, SplashState>(
                builder: (context, state) {
                  return const CircularProgressIndicator(
                      strokeWidth: 1, color: Colors.white);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
