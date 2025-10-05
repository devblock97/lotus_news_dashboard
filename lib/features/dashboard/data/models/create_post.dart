class CreatePost {
  final String title;
  final String shortDescription;
  final String body;
  final String url;

  const CreatePost({
    required this.title,
    required this.shortDescription,
    required this.body,
    required this.url,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'short_description': shortDescription,
    'body': body,
    'url': url,
  };
}
