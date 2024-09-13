import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';

Future<geo.Placemark> getUserLocation() async {
  final positon = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);

  List<geo.Placemark> placemarks =
      await geo.placemarkFromCoordinates(positon.latitude, positon.longitude);
  final geo.Placemark place = placemarks[0];
  return place;
}
