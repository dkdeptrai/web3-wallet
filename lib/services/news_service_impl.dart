import 'dart:convert';

import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/exceptions/exceptions.dart';
import 'package:web3_wallet/model/article_model.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:http/http.dart' as http;

class NewsServiceImpl implements NewsService {
  @override
  Future<List<Article>> fetchArticles({int page = 1, int size = 10}) async {
    try {
      print("Start [NewsServiceImpl.fetchArticles]");

      final String url = "${ApiConstants.newsApi}?page=$page&pageSize=$size";

      final response = await http.get(Uri.parse(url));
      print("Response [ReviewRepository.fetchReviews]: ${response.body}");
      if (response.statusCode == 200) {
        final List<Article> articles =
            jsonDecode(response.body)['articles'].map<Article>((item) => Article.fromMap(item as Map<String, dynamic>)).toList();
        return articles;
      } else {
        throw ApiException(message: "[NewsServiceImpl.fetchArticles] HTTP error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error [ReviewRepository.fetchReviews]: $e");
      throw Exception(e);
    }
  }
}
