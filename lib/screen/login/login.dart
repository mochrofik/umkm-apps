import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/login/login_bloc.dart';
import 'package:umkm_store/bloc/login/login_event.dart';
import 'package:umkm_store/bloc/login/login_state.dart';
import 'package:umkm_store/services/AuthService.dart';
import 'package:umkm_store/services/StorageService.dart';
import 'package:umkm_store/utils/GlobalColor.dart';
import 'package:umkm_store/widgets/button/PrimaryButton.dart';
import 'package:umkm_store/widgets/button/GoogleButton.dart';
import 'package:umkm_store/widgets/links/LinksCustom.dart';
import 'package:umkm_store/widgets/input/InputCustom.dart';

import 'package:umkm_store/utils/snackbar_extension.dart';

import '../register/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 2. Jangan lupa hapus dari memori saat tidak dipakai
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LoginBloc(
              authService: context.read<AuthService>(),
              storageService: context.read<StorageService>(),
            ),
        child: BlocListener<LoginBloc, LoginState>(
          listener: _onLoginStateChanged,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      // --- HEADER ---
                      const Text(
                        "Selamat Datang",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: GlobalColor.textDark,
                        ),
                      ),
                      const Text(
                        "Silahkan masuk ke akun Anda",
                        style: TextStyle(
                            fontSize: 16, color: GlobalColor.greyHint),
                      ),
                      const SizedBox(height: 40),

                      // --- INPUT EMAIL ---
                      InputCustom(
                        label: "Email",
                        hintText: "Contoh: user@mail.com",
                        controller: _emailController,
                        prefixIcon: Icons.person_outline,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),

                      // --- INPUT PASSWORD ---
                      InputCustom(
                        label: "Kata Sandi",
                        hintText: "Masukkan kata sandi",
                        controller: _passwordController,
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        isObscure: _isObscure,
                        onTogglePassword: () =>
                            setState(() => _isObscure = !_isObscure),
                      ),

                      // --- LUPA PASSWORD ---
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text("Lupa Sandi?",
                              style:
                                  TextStyle(color: GlobalColor.primaryColor)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- TOMBOL LOGIN ---
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: PrimaryButton(
                                  onPressed: state is LoginLoading
                                      ? null
                                      : () {
                                          context.read<LoginBloc>().add(
                                                LoginSubmitted(
                                                    _emailController.text,
                                                    _passwordController.text),
                                              );
                                        },
                                  text: "MASUK",
                                  isLoading: state is LoginLoading));
                        },
                      ),

                      const SizedBox(height: 30),

                      // --- DIVIDER ---
                      Row(
                        children: [
                          Expanded(
                              child: Divider(
                                  color: GlobalColor.greyHint
                                      .withValues(alpha: 0.5))),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("Atau",
                                style: TextStyle(color: GlobalColor.greyHint)),
                          ),
                          Expanded(
                              child: Divider(
                                  color: GlobalColor.greyHint
                                      .withValues(alpha: 0.5))),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // --- GOOGLE LOGIN ---
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return GoogleButton(
                            onPressed: () {
                              context
                                  .read<LoginBloc>()
                                  .add(GoogleLoginRequested());
                            },
                            isLoading: state is LoginGoogleLoading,
                          );
                        },
                      ),

                      const SizedBox(height: 40),
                      // // --- LINK DAFTAR ---
                      const Center(
                        child: Text("Belum punya akun?",
                            style: TextStyle(color: GlobalColor.greyHint)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildRegisterLink("Registrasi", () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildRegisterLink(String label, VoidCallback onTap) {
    return LinkCustoms(
      label: label,
      onTap: onTap,
    );
  }

  // --- HANDLERS ---

  void _onLoginStateChanged(BuildContext context, LoginState state) {
    if (state is LoginSuccess) {
      _handleLoginSuccess(context, state);
    } else if (state is LoginFailure) {
      context.showErrorSnackBar(state.error);
    } else if (state is LoginGoogleSuccess) {
      _handleGoogleLoginSuccess(context, state);
    }
  }

  void _handleLoginSuccess(BuildContext context, LoginSuccess state) {
    final roles = state.userData.roles;

    if (roles.contains('admin')) {
      context.showSuccessSnackBar("Login Berhasil!");
      Navigator.pushReplacementNamed(context, '/home');
    } else if (roles.contains('customer')) {
      context.showSuccessSnackBar("Login Berhasil!");
      Navigator.pushReplacementNamed(context, '/main-screen');
    } else {
      context.showErrorSnackBar("Login Gagal! Role tidak dikenali.");
    }
  }

  void _handleGoogleLoginSuccess(BuildContext context, LoginGoogleSuccess state) {
    if (state.googleLoginResponse.isNewUser) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterScreen(
            loginGoogle: state.googleLoginResponse,
          ),
        ),
      );
    } else {
      context.showSuccessSnackBar("Login Google Berhasil!");
      Navigator.pushReplacementNamed(context, '/main-screen');
    }
  }
}
