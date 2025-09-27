import 'package:flutter_test/flutter_test.dart';
import 'package:lotus_news_web/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Verify Platform version', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ArticleModel(),
          ),
        ],
        child: const NewsDashboardApp(),
      ),
    );
  });
}
