import 'package:flutter/material.dart';
import '../../location_service.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NYT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const _LandingPage(title: 'NYT'),
    );
  }
}

class _LandingPage extends StatefulWidget {
  const _LandingPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<_LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<_LandingPage> {
    LocationService _locationService = LocationService();

    @override
    void initState() {
        super.initState();
        _locationService.checkPermissions();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                            children: <Widget>[
                                Row(
                                    children: <Widget>[
                                        Text(
                                            "Current user location",
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.center,
                                        ),
                                    ],
                                ),
                                Row(
                                    children: <Widget>[
                                        Text(
                                            _locationService.locationData != null
                                                ? 'Latitude: ${_locationService.locationData.latitude}'
                                                : 'Latitude data unavailable',
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.center,
                                        ),
                                    ],
                                ),
                                Row(
                                    children: <Widget>[
                                        Text(
                                            _locationService.locationData != null
                                                ? 'Longitude: ${_locationService.locationData.longitude}'
                                                : 'Longitude data unavailable',
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.center,
                                        ),
                                    ],
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        ),
        );
    }
}