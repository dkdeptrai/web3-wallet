import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/model/models.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsService _newsService = GetIt.I<NewsService>();

  NewsCubit() : super(NewsInitial());

  Future<void> loadNews() async {
    emit(NewsLoading());
    try {
      final articles = await _newsService.fetchArticles();
      emit(NewsLoaded(articles: articles, page: 1, pageSize: articles.length));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> loadMoreNews() async {
    print("Load more news");
    final currentState = state;
    if (currentState is NewsLoaded) {
      emit(NewsLoadingMore(articles: currentState.articles, page: currentState.page, pageSize: currentState.pageSize));
      try {
        final newArticles = await _newsService.fetchArticles(page: currentState.page + 1);
        emit(NewsLoaded(
          articles: [...currentState.articles, ...newArticles],
          page: currentState.page + 1,
          pageSize: currentState.articles.length + newArticles.length,
        ));
      } catch (e) {
        emit(NewsError(e.toString()));
      }
    }
  }
}
