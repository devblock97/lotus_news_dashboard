import 'package:flutter/material.dart';
import 'package:lotus_news_web/main.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer rebuilds when ArticleModel changes
    return Consumer<ArticleModel>(
      builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              const Text('Dashboard Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Divider(),
              _buildStatsCard(
                context,
                icon: Icons.article,
                title: 'Total Articles',
                value: model.totalArticles.toString(),
                color: Colors.blue,
              ),
              _buildStatsCard(
                context,
                icon: Icons.calendar_today,
                title: 'Posted Today',
                value: model.articlesPostedToday.toString(),
                color: Colors.green,
              ),
              _buildStatsCard(
                context,
                icon: Icons.calendar_view_week,
                title: 'Posted This Week',
                value: model.articlesPostedThisWeek.toString(),
                color: Colors.orange,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsCard(BuildContext context, {required IconData icon, required String title, required String value, required Color color}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }
}