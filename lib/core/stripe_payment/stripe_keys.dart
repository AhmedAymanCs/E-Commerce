import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static String secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
  static String publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
}
