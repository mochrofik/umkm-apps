import 'package:umkm_store/model/ProductModel.dart';

class StoreNearby {
  final int id;
  final String name;
  final String slug;
  final String? logo;
  final double rating;
  final String description;
  final double latitude;
  final double longitude;
  final double jarak; // Jarak dalam KM
  final String? logoUrl;
  final String? openAt;
  final String? closeAt;
  final String? address;
  final String? phoneNumber;
  final String? isOpen; // "1" or "true" for open
  final List<MenuCategory>? menuCategories;

  StoreNearby({
    required this.id,
    required this.name,
    required this.slug,
    this.logo,
    required this.rating,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.jarak,
    this.logoUrl,
    this.openAt,
    this.closeAt,
    this.address,
    this.phoneNumber,
    this.isOpen,
    this.menuCategories,
  });

  factory StoreNearby.fromJson(Map<String, dynamic> json) {
    try {
      return StoreNearby(
        id: json['id'],
        name: json['name'] ?? '',
        slug: json['slug'] ?? '',
        logo: json['logo'],
        rating: json['rating'] != null
            ? double.tryParse(json['rating'].toString()) ?? 0.0
            : 0.0,
        description: json['description'] ?? '',
        latitude: json['latitude'] != null
            ? double.tryParse(json['latitude'].toString()) ?? 0.0
            : 0.0,
        longitude: json['longitude'] != null
            ? double.tryParse(json['longitude'].toString()) ?? 0.0
            : 0.0,
        jarak: json['jarak'] != null
            ? double.tryParse(json['jarak'].toString()) ?? 0.0
            : 0.0,
        logoUrl: json['logo_url'],
        openAt: json['open_at'],
        closeAt: json['close_at'],
        address: json['address'],
        phoneNumber: json['phone_number'],
        isOpen: json['is_open']?.toString(),
        menuCategories: json['menu_categories'] != null
            ? (json['menu_categories'] as List)
                .map((c) => MenuCategory.fromJson(c))
                .toList()
            : null,
      );
    } catch (e, stackTrace) {
      throw Exception(
          "Failed to parse store nearby $e ${stackTrace.toString()}");
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "logo": logo,
        "rating": rating.toString(),
        "description": description,
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
        "jarak": jarak.toString(),
        "logo_url": logoUrl,
        "open_at": openAt,
        "close_at": closeAt,
        "address": address,
        "phone_number": phoneNumber,
        "is_open": isOpen,
      };

  String get formattedJarak => "${jarak.toStringAsFixed(2)} km";

  String get formattedTimeRange {
    if (openAt == null || closeAt == null) return "";
    return "${openAt!.substring(0, 5)} - ${closeAt!.substring(0, 5)}";
  }
}
