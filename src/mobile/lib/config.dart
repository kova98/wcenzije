import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  String get apiRoot =>
      isProduction ? dotenv.env['API_ROOT']! : dotenv.env['API_ROOT_DEV']!;
}
