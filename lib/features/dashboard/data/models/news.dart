class Article {
  final String id;
  String title;
  String content;
  String author;
  String? imageUrl;
  final DateTime publicationDate;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    this.imageUrl,
    required this.publicationDate,
  });

  // Helper method for generating a new Article (used for dummy data)
  Article copyWith({
    String? title,
    String? content,
    String? author,
    String? imageUrl,
  }) {
    return Article(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      publicationDate: publicationDate,
    );
  }
}
