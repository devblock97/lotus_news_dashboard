import 'dart:io';

class AppConstants {
  static String baseUrl = 'http://localhost:3000/api';

  static String wsUrl(bool isRealDevice) {
    if (isRealDevice) {
      return 'ws://192.168.110.223/api/ws/posts';
    } else {
      if (Platform.isAndroid) {
        return 'ws://10.0.2.2:3000/api/ws/posts';
      } else {
        return 'ws://localhost:3000/api/ws/posts';
      }
    }
  }

  static String token = '';

  static String posts = '/posts';
  static String login = '/login';

  static String search(String keyword) {
    return '/api/news/search?q=$keyword';
  }

  static String assistant = 'http://localhost:11434/api/generate';

  static List<String> categories = [
    'Tất cả',
    'Thể thao',
    'Chính trị',
    'Âm nhạc',
    'Sự kiện',
    'Công nghệ',
    'Khoa học',
    'Giáo dục',
  ];

  static String baseLLMUrl = 'http://localhost:11434';
  static String llmToken = '';
}
