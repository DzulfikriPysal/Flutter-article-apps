import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';
import '../lib/model/article.dart';

class ArticleService {
  final http.Client httpClient;
  ArticleService(this.httpClient);

  static const String _apiKey = '5Cj5FjH9FGDx4nGawAmiu6XTfUvmK0rN';
  static const String _baseUrl = 'https://api.nytimes.com/svc/mostpopular/v2/viewed/';

  Future<List<Article>> fetchArticles({
    int page = 1,
    int pageSize = 30,
    int lastId = 0,
  }) async {
    final url = Uri.parse('$_baseUrl$pageSize.json?api-key=$_apiKey');
    final response = await httpClient.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Article> articles = [];
      for (var articleData in data['response']['docs']) {
        Article article = Article(
          id: lastId++,
          title: articleData['headline']['main'],
          published_date: articleData['pub_date'],
        );
        articles.add(article);
      }
      return articles;
    } else {
      throw Exception('Failed to fetch articles');
    }
  }
}

void main() {
  group('ArticleFetch', () {
    late ArticleService articleService;
    late http.Client httpClient;

    setUp(() {
      httpClient = MockClient((request) async {

        final articles = [
          {
            'headline': {'main': 'Article'},
            'pub_date': '2022-01-0',
          },
        ];

        return http.Response(
          jsonEncode({
            'response': {'docs': articles},
          }),
          200,
        );
      });
      articleService = ArticleService(httpClient);
    });

    // first test here
    test('searchArticles should return a list of articles', () async {
      final articles = await articleService.fetchArticles();

      expect(articles.length, 1);
    });
    
    // second test here
    test('searchArticles should throw an exception on error', () async {
      httpClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      articleService = ArticleService(httpClient);

      expect(() => articleService.fetchArticles(), throwsException);
    });
    
  });
}
