import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    if (kReleaseMode) {
      return '.env.production';
    }

    return '.env.development';
  }

  static String get getApiUrl {
    return dotenv.env['API_URL'] ?? "API_URL not specified";
  }

  static String get getChatHub {
    return dotenv.env['CHAT_HUB_URL'] ?? "API_URL not specified";
  }
}
