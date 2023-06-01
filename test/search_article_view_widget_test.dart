import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';
import '../lib/model/article.dart';

class ArticleService {
  final http.Client httpClient;

  ArticleService(this.httpClient);

  static const String _apiKey = '5Cj5FjH9FGDx4nGawAmiu6XTfUvmK0rN';
  static const String _secondBaseUrl = 'https://api.nytimes.com/svc/search/v2/articlesearch.json';

  Future<List<Article>> searchArticles({int page = 1, String? query}) async {
    int lastId = 0;
    final url = Uri.parse('$_secondBaseUrl?q=$query&page=$page&api-key=$_apiKey');
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
      throw Exception('Failed to search articles');
    }
  }
}

void main() {
  group('ArticleService', () {
    late ArticleService articleService;
    late http.Client httpClient;

    setUp(() {
      httpClient = MockClient((request) async {
        final queryParameters = request.url.queryParameters;
        final page = int.tryParse(queryParameters['page'] ?? '') ?? 1;
        final query = queryParameters['q'];

        final articles = [
          {
            'headline': {'main': 'Article $page'},
            'pub_date': '2022-01-0$page',
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

    test('searchArticles should return a list of articles', () async {
      final articles = await articleService.searchArticles();

      expect(articles.length, 1);
    });

    test('searchArticles should throw an exception on error', () async {
      httpClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      articleService = ArticleService(httpClient);

      expect(() => articleService.searchArticles(query: 'invalid'), throwsException);
    });
  });
}
