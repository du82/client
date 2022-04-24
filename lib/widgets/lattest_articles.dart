import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/cards/card1.dart';
import 'package:wordpress_app/cards/card2.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:provider/provider.dart';
import '../blocs/latest_articles_bloc.dart';
import 'loading_indicator_widget.dart';


class LattestArticles extends StatelessWidget {
  const LattestArticles({
    Key? key,required this.scaffoldKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final articles = context.watch<LatestArticlesBloc>().articles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        articles.isEmpty
            ? Container()
            : ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15),
          shrinkWrap: true,
          itemCount: articles.length,
          separatorBuilder: (ctx, idx) => Divider(
            color: Theme.of(context).dividerColor,
            thickness: 1.5,
            height: 20,
          ),
          itemBuilder: (BuildContext context, int index) {
            final Article article = articles[index];
            if(index %2 == 0) return Card2(article: article, heroTag: 'recent${article.id}',  scaffoldKey: scaffoldKey,);
            else if(index %3 == 0) return Card1(article: article, heroTag: 'recenta${article.id}',  scaffoldKey: scaffoldKey,);
            return Card2(article: article, heroTag: 'recentaa${article.id}', scaffoldKey: scaffoldKey);
          },
        ),

        Opacity(
          opacity: context.watch<LatestArticlesBloc>().loading == true ? 1.0 : 0.0,
          child: LoadingIndicatorWidget(),
        ),
      ],
    );
  }
}

