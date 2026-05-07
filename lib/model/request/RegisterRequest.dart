class RegisterRequest {
  final String role;
  final String name;
  final String email;
  final String status;
  final String phone;
  final String password;
  final String? googleId; // Opsional jika dari google

  RegisterRequest({
    required this.status,
    required this.role,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.googleId,
  });

  Map<String, dynamic> toJson() => {
        "role": role,
        "status": status,
        "name": name,
        "email": email,
        "phone_number": phone,
        "password": password,
        "google_id": googleId,
      };
}
