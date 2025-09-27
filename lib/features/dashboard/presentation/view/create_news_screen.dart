import 'package:flutter/material.dart';
import 'package:lotus_news_web/features/dashboard/data/models/news.dart';
import 'package:lotus_news_web/main.dart';
import 'package:provider/provider.dart';

class CreateArticleScreen extends StatefulWidget {
  const CreateArticleScreen({super.key});

  @override
  State<CreateArticleScreen> createState() => _CreateArticleScreenState();
}

class _CreateArticleScreenState extends State<CreateArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  String _author = '';
  String? _imageUrl; // Optional

  // 2.1.1 Post button must be available to save the article.
  void _postArticle(ArticleModel model) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newArticle = Article(
        // Simple unique ID for the prototype
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        content: _content,
        author: _author,
        imageUrl: _imageUrl!.isEmpty ? null : _imageUrl,
        publicationDate: DateTime.now(),
      );

      model.addArticle(newArticle);

      // Reset form and show success
      _formKey.currentState!.reset();
      setState(() {
        _imageUrl = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article posted successfully!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Access the model via Provider
    final articleModel = Provider.of<ArticleModel>(context, listen: false);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Create New Article',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Divider(),
            // 2.1.1 Required fields: Title
            _buildTextFormField(
              label: 'Title',
              validator: (value) => value!.isEmpty ? 'Title is required' : null,
              onSaved: (value) => _title = value!,
            ),
            const SizedBox(height: 12),
            // 2.1.1 Required fields: Author
            _buildTextFormField(
              label: 'Author',
              validator: (value) =>
                  value!.isEmpty ? 'Author is required' : null,
              onSaved: (value) => _author = value!,
            ),
            const SizedBox(height: 12),
            // 2.1.1 Required fields: Content
            _buildTextFormField(
              label: 'Content',
              maxLines: 8,
              validator: (value) =>
                  value!.isEmpty ? 'Content is required' : null,
              onSaved: (value) => _content = value!,
            ),
            const SizedBox(height: 12),
            // 2.1.1 Optional fields: Image
            _buildTextFormField(
              label: 'Image URL (Optional)',
              onSaved: (value) => _imageUrl = value,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label:
                    const Text('Post Article', style: TextStyle(fontSize: 18)),
                onPressed: () => _postArticle(articleModel),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    TextInputType keyboardType = TextInputType.text,
    String? initialValue,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
    );
  }
}
