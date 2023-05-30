import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  LocationData _locationData = LocationData.fromMap({
    "latitude": 0.0,
    "longitude": 0.0,
  });


  LocationData get locationData => _locationData;
    bool _serviceEnabled = false;
    PermissionStatus? _permissionGranted;

    Future<void> checkPermissions() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
        // Location service is still not enabled, handle accordingly.
        return;
        }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
        // Permission is still denied, handle accordingly.
        return;
        }
    }

    // Permissions have been granted, start tracking location.
    startLocationTracking();
    }

    void startLocationTracking() {
        location.onLocationChanged.listen((LocationData currentLocation) {
            _locationData = currentLocation;
        });
    }
}