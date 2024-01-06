import 'package:geolocator/geolocator.dart';

Future<Map<String, num>> getLocationFromGPS() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      // Note: You may want to handle this differently based on your app's requirements
      return Future.error('Location permissions are denied');
    }
  }

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  return {
    'latitude': position.latitude,
    'longitude': position.longitude,
  };
}
