import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/register/register_bloc.dart';
import 'package:umkm_store/bloc/register/register_event.dart';
import 'package:umkm_store/bloc/register/register_state.dart';
import 'package:umkm_store/model/GoogleLoginResponses.dart';
import 'package:umkm_store/model/request/RegisterRequest.dart';
import 'package:umkm_store/utils/GlobalColor.dart';
import 'package:umkm_store/widgets/input/InputCustom.dart';

class RegisterScreen extends StatefulWidget {
  final GoogleLoginResponse? loginGoogle;
  const RegisterScreen({super.key, this.loginGoogle});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.loginGoogle != null) {
      _nameController.text = widget.loginGoogle!.name!;
      _emailController.text = widget.loginGoogle!.email!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Pendaftaran Berhasil!")),
            );
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 500),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back Button
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon:
                              Icon(Icons.chevron_left, color: Colors.grey[600]),
                          label: Text(
                            "Kembali",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        SizedBox(height: 24),

                        Text(
                          "Daftar Sebagai Pelanggan UMKM",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Lengkapi data di bawah",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(height: 32),

                        _buildSectionHeader("Data Pribadi"),

                        InputCustom(
                          label: "Nama Lengkap",
                          hintText: "Masukkan nama lengkap",
                          controller: _nameController,
                          prefixIcon: Icons.person_outline,
                          validator: (v) =>
                              v!.isEmpty ? "Nama lengkap wajib diisi" : null,
                        ),
                        const SizedBox(height: 20),

                        InputCustom(
                          label: "Email",
                          hintText: "Masukkan email",
                          controller: _emailController,
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          readOnly: widget.loginGoogle != null,
                          validator: (v) {
                            if (v!.isEmpty) return "Email wajib diisi";
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(v)) {
                              return "Format email tidak valid";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        InputCustom(
                          label: "Nomor HP / WhatsApp",
                          hintText: "Contoh: 08123456789",
                          controller: _phoneController,
                          prefixIcon: Icons.phone_android_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),

                        InputCustom(
                          label: "Password (Min. 8 Karakter)",
                          hintText: "Masukkan password",
                          controller: _passwordController,
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          isObscure: true, // simplified for now
                          validator: (v) {
                            if (v!.isEmpty) return "Password wajib diisi";
                            if (v.length < 8) {
                              return "Password minimal 8 karakter";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GlobalColor.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed:
                                state is RegisterLoading ? null : _submitForm,
                            child: state is RegisterLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "Daftar Sekarang",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: 32),

                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                "Sudah punya akun? ",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, '/login'),
                                child: Text(
                                  "Masuk Sekarang",
                                  style: TextStyle(
                                    color: GlobalColor.primaryColor,
                                    fontWeight: FontWeight.bold,
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
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(
            RegisterSubmitted(
                request: RegisterRequest(
              role: widget.loginGoogle != null
                  ? widget.loginGoogle!.isNewUser
                      ? 'customer'
                      : 'customer'
                  : 'customer',
              status: widget.loginGoogle != null
                  ? widget.loginGoogle!.isNewUser
                      ? 'active'
                      : 'active'
                  : 'verify',
              name: _nameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
              password: _passwordController.text,
              googleId: widget.loginGoogle != null
                  ? widget.loginGoogle!.googleId
                  : "",
            )),
          );
    }
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: GlobalColor.primaryColor,
          ),
        ),
        SizedBox(height: 4),
        Divider(color: Colors.grey[200], thickness: 1),
        SizedBox(height: 16),
      ],
    );
  }
}
