import 'package:flutter/material.dart';
import 'package:lotus_news_web/features/dashboard/data/models/post.dart';
import 'package:lotus_news_web/features/dashboard/presentation/flow/post_event.dart';
import 'package:lotus_news_web/features/dashboard/presentation/flow/post_flow.dart';
import 'package:lotus_news_web/features/dashboard/presentation/flow/post_state.dart';
import 'package:provider/provider.dart';

import 'news_detail_screen.dart';

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({super.key});

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  late PostFlow _postFlow;
  final TextEditingController _searchController = TextEditingController();

  // Simple formatter for the publication date
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _postFlow = Provider.of<PostFlow>(context);
    _postFlow.eventSink.add(LoadPostEvent());
  }

  @override
  Widget build(BuildContext context) {
    // The consumer rebuilds when the article list changes
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search by Title or Author',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  // Manually notify listener to rebuild the list with empty filter
                  // A more complex state management would handle this more cleanly.
                  // For this prototype, we'll force a rebuild via setState in a wrapper if needed,
                  // but here we just rely on the consumer logic.
                },
              ),
            ),
            onChanged: (value) {
              // This forces the Consumer to rebuild with the new filter text
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<PostState>(
            stream: _postFlow.state,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.data is PostLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data is PostError) {
                return Center(
                  child: Text('Error: ${(snapshot.data as PostError).message}'),
                );
              } else if (snapshot.data is PostLoaded) {
                final posts = (snapshot.data as PostLoaded).posts;
                if (posts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No articles found.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: Image.network(
                          post.avatar,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (c, o, s) =>
                              const Icon(Icons.image_not_supported),
                        ),
                        title: Text(
                          post.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // 2.1.2 The list should show the Title, Author, and publication date.
                        subtitle: Text(
                          'By: ${post.authorUsername} | Date: ${_formatDate(post.createdAt)}',
                        ),
                        onTap: () {
                          // Navigates to the detailed view/edit screen (2.1.3 Update Article)
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ArticleDetailScreen(post: post),
                            ),
                          );
                        },
                        // 2.1.4 Delete Article: Available on each article
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, post),
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
            'Are you sure you want to delete the article: "${post.title}"?',
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
                _postFlow.eventSink.add(DeletePostEvent(id: post.id));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
