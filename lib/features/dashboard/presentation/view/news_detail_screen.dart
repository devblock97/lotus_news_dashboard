import 'package:flutter/material.dart';
import 'package:lotus_news_web/features/dashboard/data/models/post.dart';
import 'package:lotus_news_web/features/dashboard/presentation/flow/post_event.dart';
import 'package:lotus_news_web/features/dashboard/presentation/flow/post_flow.dart';
import 'package:provider/provider.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Post post;

  const ArticleDetailScreen({super.key, required this.post});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late PostFlow _postFlow;

  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  late String _author;
  late String? _imageUrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _postFlow = Provider.of<PostFlow>(context);
  }

  @override
  void initState() {
    super.initState();
    // Initialize state with existing article data
    _title = widget.post.title;
    _content = widget.post.body;
    _author = widget.post.authorUsername;
    _imageUrl = widget.post.url;
  }

  // 2.1.3 Save button must be available to update changes.
  void _saveArticle(Post model) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedArticle = widget.post.copyWith(
        title: _title,
        body: _content,
        authorUsername: _author,
        url: _imageUrl!.isEmpty ? null : _imageUrl,
      );

      _postFlow.eventSink.add(UpdatePostEvent(updatedArticle));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article updated successfully!')),
      );

      // Pop back to the article list
      Navigator.of(context).pop();
    }
  }

  // 2.1.4 Delete Article: Available on the detailed view screen.
  void _confirmDelete(BuildContext context, Post model) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
            'Are you sure you want to delete the article: "${widget.post.title}"?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Pop confirmation dialog
                Navigator.of(context).pop(); // Pop detail screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Article deleted successfully!'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Article'),
        actions: [
          // 2.1.4 Delete button on detailed view
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, widget.post),
            tooltip: 'Delete Article',
            color: Colors.redAccent,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Fields are pre-filled with existing data
              _buildTextFormField(
                label: 'Title',
                initialValue: widget.post.title,
                validator: (value) =>
                    value!.isEmpty ? 'Title is required' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 12),
              _buildTextFormField(
                label: 'Author',
                initialValue: widget.post.authorUsername,
                validator: (value) =>
                    value!.isEmpty ? 'Author is required' : null,
                onSaved: (value) => _author = value!,
              ),
              const SizedBox(height: 12),
              _buildTextFormField(
                label: 'Content',
                maxLines: 8,
                initialValue: widget.post.body,
                validator: (value) =>
                    value!.isEmpty ? 'Content is required' : null,
                onSaved: (value) => _content = value!,
              ),
              const SizedBox(height: 12),
              _buildTextFormField(
                label: 'Image URL (Optional)',
                initialValue: widget.post.url,
                onSaved: (value) => _imageUrl = value,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () => _saveArticle(widget.post),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
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
