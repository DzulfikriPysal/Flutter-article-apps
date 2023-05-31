import 'package:location/location.dart';
import 'package:flutter/material.dart';

class LocationService {
  Location location = Location();
  LocationData? _locationData;

  LocationData? get locationData => _locationData;

  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;

  Future<LocationData?> checkPermissions() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // Location service is still not enabled, handle accordingly.
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // Permission is still denied, handle accordingly.
        return null;
      }
    }

    // Permissions have been granted, start tracking location.
    _locationData = await location.getLocation();
    return _locationData;
  }

  void startLocationTracking() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      _locationData = currentLocation;
    });
  }

  Widget buildLocationRow(String label, double? latitude, double? longitude) {
    String valueText = latitude != null && longitude != null
        ? 'Latitude: $latitude, \n Longitude: $longitude'
        : 'Location data unavailable';

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              label,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              latitude != null ? 'Latitude: $latitude' : 'Latitude unavailable',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              longitude != null ? 'Longitude: $longitude' : 'Longitude unavailable',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
