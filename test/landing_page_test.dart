import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:location/location.dart';
import 'package:article_app/service/location_service.dart';

class MockLocationService extends Mock implements LocationService {
  Future<LocationData?> fetchLocationData() async { // when location return latitude and longitude
    return LocationData.fromMap({
      "latitude": 2.9221,
      "longitude": 101.6510,
    });
  }
  Future<LocationData?> fetchNullLocationData() async { // when location return null
    return null;
  }
}

void main() {
  group('LandingPage Test', () {
    late MockLocationService mockLocationService;

    setUp(() {
      mockLocationService = MockLocationService();
    });


    // first test here
    test('Test location data availability', () async {
      // do
      final locationData = await mockLocationService.fetchLocationData();

      // test
      expect(locationData, isNotNull);
    });

    // second test here
    test('Test location data availability when unavailable', () async {
      // do
      final locationData = await mockLocationService.fetchNullLocationData();

      // test
      expect(locationData, isNull);
    });
  });
}
