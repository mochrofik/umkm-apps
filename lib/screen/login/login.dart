
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/login/login_bloc.dart';
import 'package:umkm_store/bloc/login/login_event.dart';
import 'package:umkm_store/bloc/login/login_state.dart';
import 'package:umkm_store/services/AuthRepository.dart';
import 'package:umkm_store/utils/GlobalColor.dart';
import 'package:umkm_store/widgets/button/PrimaryButton.dart';
import 'package:umkm_store/widgets/button/GoogleButton.dart';
import 'package:umkm_store/widgets/links/LinksCustom.dart';

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
      create: (context) =>
          LoginBloc(authRepository: context.read<AuthRepository>()),
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
                    style: TextStyle(fontSize: 16, color: GlobalColor.greyHint),
                  ),
                  const SizedBox(height: 40),

                  // --- INPUT EMAIL ---
                  const Text("Email",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Contoh: user@mail.com",
                      prefixIcon: const Icon(Icons.person_outline,
                          color: GlobalColor.primaryColor),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- INPUT PASSWORD ---
                  const Text("Kata Sandi",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    obscureText: _isObscure,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "Masukkan kata sandi",
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: GlobalColor.primaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () =>
                            setState(() => _isObscure = !_isObscure),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),

                  // --- LUPA PASSWORD ---
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Lupa Sandi?",
                          style: TextStyle(color: GlobalColor.primaryColor)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- TOMBOL LOGIN ---

                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Login Berhasil!"),
                              backgroundColor: Colors.green),
                        );
                        Navigator.pushReplacementNamed(context, '/home');
                      } else if (state is LoginFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(state.error),
                              backgroundColor: Colors.red),
                        );
                      }
                    },
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
                              color: GlobalColor.greyHint.withOpacity(0.5))),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Atau",
                            style: TextStyle(color: GlobalColor.greyHint)),
                      ),
                      Expanded(
                          child: Divider(
                              color: GlobalColor.greyHint.withOpacity(0.5))),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- GOOGLE LOGIN ---
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return GoogleButton(
                        onPressed: () {
                          context.read<LoginBloc>().add(GoogleLoginRequested());
                        },
                        isLoading: state is LoginLoading,
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
    );
  }

  Widget _buildRegisterLink(String label, VoidCallback onTap) {
    return LinkCustoms(
      label: label,
      onTap: onTap,
    );
  }
}
