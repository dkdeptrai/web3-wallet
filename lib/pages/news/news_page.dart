import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/common_widgets/custom_loading_widget.dart';
import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/pages/pages.dart';
import 'package:web3_wallet/resources/resources.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  static const String routeName = "/news-page";

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    context.read<NewsCubit>().loadNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.defaultHorizontalPadding),
              child: Text(
                "Insights",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: BlocBuilder<NewsCubit, NewsState>(
                builder: (context, state) {
                  if (state is NewsLoading) {
                    return const Center(child: CustomLoadingWidget());
                  }
                  if (state is NewsError) {
                    return Center(
                      child: Text(
                        "Something went wrong. Please try again later.",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    );
                  }
                  if (state is NewsLoaded) {
                    final articles = state.articles;
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.defaultHorizontalPadding),
                      itemCount: 10,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 20);
                      },
                      itemBuilder: (context, index) {
                        final item = articles[index];
                        return Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(
                            onTap: () => _navigateToArticleDetailsPage(
                              url: item.url ?? "",
                              title: item.title ?? "",
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item.imageUrl ?? "",
                                        width: size.width * 0.25,
                                        height: size.width * 0.25,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title ?? "",
                                            style: Theme.of(context).textTheme.titleMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item.description ?? "",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: appColors.subTitle),
                                ),
                                const SizedBox(height: 10),
                                if (item.author != null)
                                  Text(
                                    DateFormat("yyyy-MM-dd hh:mm").format(item.publishedAt!),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: appColors.title),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToArticleDetailsPage({required String url, required String title}) {
    Navigator.pushNamed(context, ArticleDetailsPage.routeName, arguments: {
      "url": url,
      "title": title,
    });
  }
}
