import 'package:web3_wallet/model/models.dart';

abstract class NewsService {
  Future<List<Article>> fetchArticles({int page = 1, int size = 10});
}
