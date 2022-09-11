import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition() async {
  var error = await getPermissionError();
  if (error != null) {
    return Future.error(error);
  }

  return await Geolocator.getCurrentPosition();
}

Future<String?> requestPermission() async {
  await Geolocator.requestPermission();
  return getPermissionError();
}

Future<String?> getPermissionError() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return 'Molim te, uključi lokaciju.';
  }

  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    return 'Molim te, dozvoli pristup lokaciji.';
  }

  if (permission == LocationPermission.deniedForever) {
    return 'Molim te, u postavkama dozvoli pristup lokaciji.';
  }

  return null;
}
