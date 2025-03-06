import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article_model.dart';

class ArticleService {
  static const String _apiKey = 'b4d58d6075b74574a572d16d255fc2a7'; // Replace with your NewsAPI key
  static const String _baseUrl = 'https://newsapi.org/v2/everything';

  Future<List<Article>> fetchArticles() async {
    // Keywords for nutrition and food
    String keywords = 'nutritious eating';
    final response = await http.get(Uri.parse('$_baseUrl?q=$keywords&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final articles = json['articles'] as List;

      // Map JSON data to Article objects
      return articles.map((articleJson) => Article.fromJson(articleJson)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
