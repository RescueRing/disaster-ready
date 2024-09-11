import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerDetails {
  final String name;

  final String phone;
  final String email;

  final bool isHelping;

  final double latitude;
  final double longitude;
  final LatLng address;
  final List selectedFilter;

  MarkerDetails(
      // MarkerDetails markerDetails,
      {
    this.name = 'Name 1',
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.isHelping,
    this.email = 'email.com',
    required this.selectedFilter,
  });

  factory MarkerDetails.fromJson(Map<String, dynamic> json) {
    print(json);
    return MarkerDetails(
      name: json['name'] ?? 'Name 1',
      address: LatLng(
          double.parse(json['latitude']), double.parse(json['longitude'])),
      phone: json['phone'],
      email: json['email'] ?? 'email.com',
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      isHelping: json['isHelping'],
      selectedFilter: json['selectedFilter'],
    );
  }
}
