import 'package:umkm_store/model/UserModel.dart';

class GoogleLoginResponse {
  final bool isNewUser; // true jika user harus buat password/registrasi
  final UserData? userData; // terisi jika user sudah ada
  final String? token; // token dari backend jika sudah ada

  // Data dari Google untuk registrasi jika user baru
  final String? googleId;
  final String? email;
  final String? name;

  GoogleLoginResponse({
    required this.isNewUser,
    this.userData,
    this.token,
    this.googleId,
    this.email,
    this.name,
  });

  factory GoogleLoginResponse.fromJson(Map<String, dynamic> json) {
    return GoogleLoginResponse(
      isNewUser: json['create_password'] ?? false,
      userData:
          json['userData'] != null ? UserData.fromJson(json['userData']) : null,
      token: json['token'],
      googleId: json['uid'],
      email: json['email'],
      name: json['name'],
    );
  }
}
