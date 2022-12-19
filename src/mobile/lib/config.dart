import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  String get apiRoot => dotenv.env['API_ROOT']!;
}
