import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:umkm_store/model/GoogleLoginResponses.dart';
import 'package:umkm_store/model/UserModel.dart';
import 'package:umkm_store/services/AuthRepository.dart';
import 'package:umkm_store/services/StorageService.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  final AuthRepository authRepository = AuthRepository();
  final StorageService storageService = StorageService();
  final logger = Logger();

  Future<UserData?> login(String email, String password) async {
    try {
      final response = await authRepository.login(email, password);

      if (response.statusCode == 200) {
        final UserData userData =
            UserData.fromJson(response.data['data']['user']);

        if (userData.roles.isNotEmpty && userData.roles.contains('customer') ||
            userData.roles.contains('admin')) {
          await storageService.saveToken(response.data['data']['access_token']);

          await storageService.saveUser(userData);

          return userData;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      log("service error ${e.toString()} ");
      throw Exception(e);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      log("google user json ${googleUser.toString()}");

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      log("google auth ${googleAuth.idToken}");
      log("google auth ${googleAuth.accessToken}");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<void> signOutWithGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<GoogleLoginResponse?> checkLoginGoogleApp(
      String uid, String email, String name) async {
    try {
      final response =
          await authRepository.checkLoginGoogleApp(uid, email, name);

      if (response.statusCode == 200) {
        final GoogleLoginResponse googleLoginResponse =
            GoogleLoginResponse.fromJson(response.data['data']);

        if (!googleLoginResponse.isNewUser) {
          await storageService.saveToken(response.data['data']['access_token']);

          await storageService
              .saveUser(UserData.fromJson(response.data['data']['user']));
        }
        return googleLoginResponse;
      }
      return null;
    } catch (e) {
      logger.e("error login google app ${e.toString()}");
      throw Exception(e);
    }
  }
}
