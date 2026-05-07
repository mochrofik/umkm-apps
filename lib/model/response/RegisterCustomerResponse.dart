class RegisterCustomerResponse {
  final int? id;
  final int? userId;
  final String? nik;
  final String? phoneNumber;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? address;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RegisterCustomerResponse({
    this.id,
    this.userId,
    this.nik,
    this.phoneNumber,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory RegisterCustomerResponse.fromJson(Map<String, dynamic> json) {
    return RegisterCustomerResponse(
      id: json['id'],
      userId: json['user_id'],
      nik: json['nik'],
      phoneNumber: json['phone_number']?.toString(),
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      address: json['address'],
      postalCode: json['postal_code'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      avatarUrl: json['avatar_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "nik": nik,
        "phone_number": phoneNumber,
        "gender": gender,
        "date_of_birth": dateOfBirth?.toIso8601String(),
        "address": address,
        "postal_code": postalCode,
        "latitude": latitude,
        "longitude": longitude,
        "avatar_url": avatarUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
