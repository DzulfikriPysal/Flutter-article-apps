import 'package:flutter/material.dart';
import '../../service/location_service.dart';
import '../../model/article.dart';
import '../../service/article_service.dart';
import 'package:location/location.dart';

class SearchArticleView extends StatefulWidget {
  @override
  _SearchArticleViewState createState() => _SearchArticleViewState();
}

class _SearchArticleViewState extends State<SearchArticleView> {
  TextEditingController _searchController = TextEditingController();
  List<Article> _searchResults = [];
  bool _isLoading = false;
  int _page = 1;
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

  void _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _page = 1; // Reset the page number when performing a new search
      _searchResults.clear(); // Clear the existing search results
    });

    // Call the article service to search for articles
    ArticleService articleService = ArticleService();
    List<Article> results = await articleService.searchArticles(page: _page, query: query);

    setState(() {
      _searchResults.addAll(results);
      _isLoading = false;
    });
  }

  void _loadMoreArticles() async {
    if (_isLoading) {
      return; // Prevent multiple simultaneous requests
    }

    setState(() {
      _isLoading = true;
      _page++; // Increment the page number for the next request
    });

    // Call the article service to fetch more articles
    ArticleService articleService = ArticleService();
    List<Article> results = await articleService.searchArticles(page: _page, query: _searchController.text);

    setState(() {
      _searchResults.addAll(results);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: _locationService.buildLocationRow(
              "Current user location",
              _locationService.locationData?.latitude,
              _locationService.locationData?.longitude,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    String query = _searchController.text;
                    _performSearch(query);
                  },
                ),
              ),
            ),
          ),
          _isLoading
              ? CircularProgressIndicator()
              : Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo is ScrollEndNotification &&
                          scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                        // Reached the end of the list, load more articles
                        _loadMoreArticles();
                        return true;
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: _searchResults.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == _searchResults.length) {
                          // Show a loading indicator at the end of the list while loading more articles
                          return _isLoading ? CircularProgressIndicator() : SizedBox.shrink();
                        }

                        Article article = _searchResults[index];
                        return ListTile(
                          title: Text(article.title),
                          subtitle: Text(article.published_date),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
