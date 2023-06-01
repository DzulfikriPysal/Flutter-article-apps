import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';

import '../../service/location_service.dart';
import '../../model/article.dart';
import '../../service/article_service.dart';

class MostView extends StatefulWidget {
  const MostView({Key? key}) : super(key: key);

  @override
  State<MostView> createState() => _MostViewState();
}

class _MostViewState extends State<MostView> {
  ArticleService _articleService = ArticleService();
  List<Article> _articles = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _pageSize = 30;
  LocationService _locationService = LocationService();
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    _loadArticles();
    _locationService.checkPermissions().then((locationData) {
      setState(() {
        _locationData = locationData;
      });
    });
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final articles = await _articleService.fetchArticles(
        page: _currentPage,
        pageSize: _pageSize,
      );
      setState(() {
        _articles.addAll(articles);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Articles"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _locationService.buildLocationRow(
                "Current user location",
                _locationService.locationData?.latitude,
                _locationService.locationData?.longitude,
              ),
              SizedBox(height: 20),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (!_isLoading &&
                        scrollNotification.metrics.pixels ==
                            scrollNotification.metrics.maxScrollExtent) {
                      _currentPage++;
                      _loadArticles();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: _articles.length + 1,
                    itemBuilder: (context, index) {
                      if (index < _articles.length) {
                        final article = _articles[index];
                        return ListTile(
                          title: Text(article.title),
                          subtitle: Text(article.published_date),
                        );
                      } else if (_isLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
