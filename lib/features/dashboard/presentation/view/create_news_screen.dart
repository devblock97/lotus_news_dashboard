import 'package:flutter/material.dart';
import 'package:lotus_news_web/features/auth/presentation/flow/auth_flow.dart';
import 'package:lotus_news_web/features/auth/presentation/flow/auth_state.dart';
import 'package:lotus_news_web/features/dashboard/data/models/create_post.dart';
import 'package:lotus_news_web/features/dashboard/presentation/flow/post_event.dart';
import 'package:lotus_news_web/features/dashboard/presentation/flow/post_flow.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/view/login_screen.dart';

class CreateArticleScreen extends StatefulWidget {
  const CreateArticleScreen({super.key});

  @override
  State<CreateArticleScreen> createState() => _CreateArticleScreenState();
}

class _CreateArticleScreenState extends State<CreateArticleScreen> {
  late PostFlow _postFlow;
  late AuthFlow _authFlow;

  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  String _shortDescription = '';
  String _imageUrl = ''; // Optional

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _postFlow = Provider.of<PostFlow>(context);
    _authFlow = Provider.of<AuthFlow>(context);
  }

  void _postArticle() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final post = CreatePost(
        title: _title,
        body: _content,
        url: _imageUrl,
        shortDescription: _shortDescription,
      );

      _postFlow.eventSink.add(CreatePostEvent(post: post));

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
    return StreamBuilder<AuthState>(
      stream: _authFlow.state,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data is Authenticated) {
          return _buildCreatePost();
        } else if (snapshot.hasError) {
          return Text('Something went wrong');
        } else {
          return LoginScreen();
        }
      },
    );
  }

  Widget _buildCreatePost() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Create New Article',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildTextFormField(
              label: 'Title',
              validator: (value) => value!.isEmpty ? 'Title is required' : null,
              onSaved: (value) => _title = value!,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              label: 'Short description',
              validator: (value) =>
                  value!.isEmpty ? 'Author is required' : null,
              onSaved: (value) => _shortDescription = value!,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              label: 'Content',
              maxLines: 8,
              validator: (value) =>
                  value!.isEmpty ? 'Content is required' : null,
              onSaved: (value) => _content = value!,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              label: 'Image URL (Optional)',
              onSaved: (value) => _imageUrl = value!,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text(
                  'Create Post',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: _postArticle,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
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
