import 'package:logger/web.dart';

final logger = Logger(
    printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true));
