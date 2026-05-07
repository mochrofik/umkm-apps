import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constans {
  static String baseUrl = dotenv.env['BASE_URL']!;
  static String apiUrl = "$baseUrl/api/";
}
