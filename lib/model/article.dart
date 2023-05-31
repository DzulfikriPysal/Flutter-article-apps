class Article {
  final int id;
  final String title;
  final String published_date;

  Article({required this.id, required this.title, required this.published_date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'published_date': published_date,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'],
      title: map['title'],
      published_date: map['published_date'],
    );
  }
}
