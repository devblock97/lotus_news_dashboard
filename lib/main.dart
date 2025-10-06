import 'package:flutter/material.dart';
import 'package:lotus_news_web/core/network/auth_interceptor.dart';
import 'package:lotus_news_web/core/network/client_network.dart';
import 'package:lotus_news_web/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:lotus_news_web/features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart';
import 'package:lotus_news_web/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lotus_news_web/features/auth/data/repositories/token_storage_repository.dart';
import 'package:lotus_news_web/features/auth/domain/repositories/auth_repository.dart';
import 'package:lotus_news_web/features/auth/domain/repositories/token_storage_repository.dart';
import 'package:lotus_news_web/features/auth/domain/usecases/login_usecase.dart';
import 'package:lotus_news_web/features/auth/presentation/flow/auth_flow.dart';
import 'package:lotus_news_web/features/dashboard/data/data_source/remote_data_source/post_remote_data_source.dart';
import 'package:lotus_news_web/features/dashboard/data/repositories/post_repository_impl.dart';

import 'package:lotus_news_web/features/dashboard/domain/repositories/post_repository.dart';
import 'package:lotus_news_web/features/dashboard/domain/usecases/create_post_usecase.dart';
import 'package:lotus_news_web/features/dashboard/domain/usecases/delete_post_usecase.dart';
import 'package:lotus_news_web/features/dashboard/domain/usecases/get_post_usecase.dart';
import 'package:lotus_news_web/features/dashboard/domain/usecases/update_post_usecase.dart';
import 'package:lotus_news_web/features/dashboard/presentation/flow/post_flow.dart';
import 'package:provider/provider.dart';

import 'features/auth/presentation/view/account_screen.dart';
import 'features/dashboard/data/models/news.dart';
import 'features/dashboard/presentation/view/create_news_screen.dart';
import 'features/dashboard/presentation/view/dashboard_screen.dart';
import 'features/dashboard/presentation/view/news_list_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ArticleModel()),

        Provider<AuthLocalDataSource>(
          create: (context) => AuthLocalDataSourceImpl(),
        ),
        Provider<TokenStorageRepository>(
          create: (context) =>
              TokenStorageRepositoryImpl(context.read<AuthLocalDataSource>()),
        ),

        /// Network
        Provider(
          create: (context) => AuthInterceptor(
            tokenStorageRepository: context.read<TokenStorageRepository>(),
          ),
        ),
        Provider(
          create: (context) =>
              ClientNetwork(authInterceptor: context.read<AuthInterceptor>()),
        ),

        /// Data Layer
        Provider<AuthRemoteDataSource>(
          create: (context) =>
              AuthRemoteDataSourceImpl(context.read<ClientNetwork>()),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            context.read<AuthRemoteDataSource>(),
            context.read<AuthLocalDataSource>(),
          ),
        ),
        Provider<PostRemoteDataSource>(
          create: (context) =>
              PostRemoteDataSourceImpl(context.read<ClientNetwork>()),
        ),
        Provider<PostRepository>(
          create: (context) =>
              PostRepositoryImpl(context.read<PostRemoteDataSource>()),
        ),

        /// Domain Layer (Use Cases)
        Provider<CreatePostUseCase>(
          create: (context) =>
              CreatePostUseCase(context.read<PostRepository>()),
        ),
        Provider<GetPostUseCase>(
          create: (context) => GetPostUseCase(context.read<PostRepository>()),
        ),
        Provider<UpdatePostUseCase>(
          create: (context) =>
              UpdatePostUseCase(context.read<PostRepository>()),
        ),
        Provider(
          create: (context) => LoginUseCase(context.read<AuthRepository>()),
        ),
        Provider(
          create: (context) =>
              DeletePostUseCase(context.read<PostRepository>()),
        ),

        /// Presentation Layer (BLoc)
        Provider<PostFlow>(
          create: (context) => PostFlow(
            createPostUseCase: context.read<CreatePostUseCase>(),
            getPostUseCase: context.read<GetPostUseCase>(),
            updatePostUseCase: context.read<UpdatePostUseCase>(),
            deletePostUseCase: context.read<DeletePostUseCase>(),
          ),
          dispose: (_, flow) => flow.dispose(),
        ),
        Provider(
          create: (context) =>
              AuthFlow(loginUseCase: context.read<LoginUseCase>()),
          dispose: (_, flow) => flow.dispose(),
        ),
      ],
      child: const NewsDashboardApp(),
    ),
  );
}

class ArticleModel extends ChangeNotifier {
  final List<Article> _articles = [
    Article(
      id: '1',
      title: 'Flutter UI State Management',
      content:
          'Understanding Provider and its role in managing application state...',
      author: 'Jane Doe',
      publicationDate: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Article(
      id: '2',
      title: 'Backend with PostgreSQL and Dart',
      content: 'Connecting a Flutter app to a robust PostgreSQL database...',
      author: 'John Smith',
      publicationDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Article(
      id: '3',
      title: 'Responsive Design in Flutter',
      content:
          'Ensuring the UI is intuitive and responsive on mobile and tablets...',
      author: 'A. Tester',
      publicationDate: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ];

  List<Article> get articles => _articles;

  // --- Functional Requirement 2.1: Article Management (CRUD) ---

  // 2.1.1 Create Article
  void addArticle(Article article) {
    // In a real app, 'id' would be generated by the backend
    // and 'publicationDate' would be set on creation.
    _articles.add(article);
    notifyListeners();
  }

  // 2.1.3 Update Article
  void updateArticle(Article updatedArticle) {
    final index = _articles.indexWhere((a) => a.id == updatedArticle.id);
    if (index != -1) {
      _articles[index] = updatedArticle;
      notifyListeners();
    }
  }

  // 2.1.4 Delete Article
  void deleteArticle(String id) {
    _articles.removeWhere((article) => article.id == id);
    notifyListeners();
  }

  // --- Functional Requirement 2.2: Dashboard Overview ---

  int get totalArticles => _articles.length;

  int get articlesPostedToday {
    final today = DateTime.now();
    return _articles.where((article) {
      return article.publicationDate.year == today.year &&
          article.publicationDate.month == today.month &&
          article.publicationDate.day == today.day;
    }).length;
  }

  int get articlesPostedThisWeek {
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));
    return _articles
        .where((article) => article.publicationDate.isAfter(oneWeekAgo))
        .length;
  }
}

class NewsDashboardApp extends StatelessWidget {
  const NewsDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(),
    ArticleListScreen(),
    const CreateArticleScreen(),
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Non-Functional Requirement: Responsive Design
    bool isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      // Mobile Layout: Bottom Navigation
      return Scaffold(
        appBar: AppBar(title: const Text('News Dashboard')),
        body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
        // 2.2 Navigation: Bottom Navigation
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Articles',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          onTap: _onItemTapped,
        ),
      );
    } else {
      // Tablet/Desktop Layout: Sidebar Navigation
      return Scaffold(
        appBar: AppBar(title: const Text('Lotus News - Admin Panel')),
        body: Row(
          children: <Widget>[
            // 2.2 Navigation: Sidebar Navigation
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              labelType: NavigationRailLabelType.all,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.list_alt),
                  selectedIcon: Icon(Icons.list_alt),
                  label: Text('Article List'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add_circle),
                  selectedIcon: Icon(Icons.add_circle),
                  label: Text('Create'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person_outline),
                  label: Text('Account'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            // Main content area
            Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
          ],
        ),
      );
    }
  }
}
