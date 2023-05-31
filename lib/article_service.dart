import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model/article.dart';

class ArticleService {
  static const String _apiKey = '5Cj5FjH9FGDx4nGawAmiu6XTfUvmK0rN';
  static const String _baseUrl = 'https://api.nytimes.com/svc/mostpopular/v2/viewed/';
  static const String _secondBaseUrl = 'https://api.nytimes.com/svc/search/v2/articlesearch.json';

  Future<List<Article>> fetchArticles({
    int page = 1,
    int pageSize = 30,
    int lastId = 0,
  }) async {
    final url = Uri.parse('$_baseUrl$pageSize.json?api-key=$_apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Article> articles = [];
        for (var articleData in data['results']) {
          Article article = Article(
            id: lastId++,
            title: articleData['title'],
            published_date: articleData['published_date'],
          );
          articles.add(article);
        }
        // Save articles to local database
        await _saveArticlesToDB(articles);
        return articles;
      }
    } catch (e) {
      print('Error fetching articles from the server: $e');
    }

    // If there was an error or no internet connection, load articles from the local database
    return _loadArticlesFromDB();
  }
  
  Future<List<Article>> searchArticles({
    int page = 1,
    String? query,
  }) async {
    int lastId = 0;
    final url = Uri.parse('$_secondBaseUrl?q=$query&page=$page&api-key=$_apiKey');
    final response = await http.get(url);
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

  Future<void> _saveArticlesToDB(List<Article> articles) async {
    final dbPath = await getDatabasesPath();
    final databasePath = join(dbPath, 'articles.db');

    final db = await openDatabase(
      databasePath,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS articles(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, published_date TEXT)',
        );
      },
      version: 1,
    );

    for (var article in articles) {
      await db.insert(
        'articles',
        article.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await db.close();
  }

  Future<List<Article>> _loadArticlesFromDB() async {
    final dbPath = await getDatabasesPath();
    final databasePath = join(dbPath, 'articles.db');

    final db = await openDatabase(databasePath);
    final List<Map<String, dynamic>> maps = await db.query('articles');
    await db.close();

    return List.generate(maps.length, (index) {
      return Article.fromMap(maps[index]);
    });
  }
}
