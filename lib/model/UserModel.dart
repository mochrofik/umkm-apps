class UserModel {
  final List<String> roles;
  final UserData user;

  UserModel({
    required this.roles,
    required this.user,
  });
}

class UserData {
  final int id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String role;
  final List<String> roles;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.role,
    required this.roles,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      emailVerifiedAt: json["email_verified_at"] == null
          ? null
          : DateTime.parse(json["email_verified_at"]),
      role: json["role"],
      roles: json["roles"] == null
          ? []
          : List<String>.from(json["roles"]!.map((x) => x["name"])),
      status: json["status"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  factory UserData.fromKey(Map<String, dynamic> json) {
    return UserData(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      emailVerifiedAt: json["email_verified_at"] == null
          ? null
          : DateTime.parse(json["email_verified_at"]),
      role: json["role"],
      roles: json["roles"] == null ? [] : List<String>.from(json["roles"]),
      status: json["status"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "role": role,
        "roles": roles,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
