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
  });

  factory StoreNearby.fromJson(Map<String, dynamic> json) {
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
    );
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
      };

  String get formattedJarak => "${jarak.toStringAsFixed(2)} km";
}
