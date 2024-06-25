// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Article {
  int? id;
  String? title;
  String? source;
  String? author;
  String? url;
  String? imageUrl;
  String? description;
  DateTime? publishedAt;
  Article({
    this.id,
    this.title,
    this.source,
    this.author,
    this.url,
    this.imageUrl,
    this.description,
    this.publishedAt,
  });

  Article copyWith({
    int? id,
    String? title,
    String? source,
    String? author,
    String? url,
    String? imageUrl,
    String? description,
    DateTime? publishedAt,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      source: source ?? this.source,
      author: author ?? this.author,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'source': source,
      'author': author,
      'url': url,
      'imageUrl': imageUrl,
      'description': description,
      'publishedAt': publishedAt,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      source: map['source'] != null ? map['source'] as String : null,
      author: map['author'] != null ? map['author'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      publishedAt: map['publishedAt'] != null ? DateTime.parse(map['publishedAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Article.fromJson(String source) => Article.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Article(id: $id, title: $title, source: $source, author: $author, url: $url, imageUrl: $imageUrl, description: $description, publishedAt: $publishedAt)';
  }
}
