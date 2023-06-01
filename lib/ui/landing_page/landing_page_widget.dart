import 'package:flutter/material.dart';
import '../../service/location_service.dart';
import '../search_article_view/search_article_view_widget.dart';
import '../most_view/most_view_widget.dart';
import 'package:location/location.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NYT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _LandingPage(title: "NYT"),
    );
  }
}

class _LandingPage extends StatefulWidget {
  final String title;

  const _LandingPage({Key? key, required this.title}) : super(key: key);

  @override
  State<_LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<_LandingPage> {
    LocationService _locationService = LocationService();
    LocationData? _locationData;

    @override
    void initState() {
        super.initState();
        _locationService.checkPermissions().then((locationData) {
            setState(() {
            _locationData = locationData;
            });
        });
    }

    Widget buildLocationRow(String label, double? latitude, double? longitude) {
        return Column(
            children: <Widget>[
                Row(
                    children: <Widget>[
                        Text(
                            label,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                        ),
                    ]
                ),
                Row(
                    children: <Widget>[
                        Text(
                            latitude != null
                            ? 'Latitude: $latitude'
                            : 'Latitude unavailable',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                        ),
                    ]
                ),
                Row(
                    children: <Widget>[
                        Text(
                            longitude != null
                            ? 'Longitude: $longitude'
                            : 'Longitude unavailable',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                        ),
                    ]
                ),
            ],
        );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              buildLocationRow(
                "Current user location",
                _locationService.locationData?.latitude,
                _locationService.locationData?.longitude,
              ),
              SizedBox(height: 40),
              Row(
                children: <Widget>[
                  Text(
                    "Search",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Card(
                elevation: 3,
                child: ListTile(
                  title: Text('Search Articles'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchArticleView(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 40),
              Row(
                children: <Widget>[
                  Text(
                    "Popular",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Card(
                elevation: 3,
                child: ListTile(
                  title: Text('Most Viewed'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MostView(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
