import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/blocs/popular_articles_bloc.dart';
import 'package:wordpress_app/cards/card1.dart';
import 'package:wordpress_app/cards/card6.dart';
import 'package:wordpress_app/pages/popular_articles_page.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import 'package:wordpress_app/utils/vertical_line.dart';
import '../utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class PopularArticles extends StatelessWidget {
  const PopularArticles({Key? key, required this.scaffoldKey})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    PopularArticlesBloc pb = context.watch<PopularArticlesBloc>();
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 0, right: 15),
      child: Column(
        children: [
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 5, bottom: 0),
            itemCount: pb.articles.isEmpty ? 3 : pb.articles.length,
            separatorBuilder: (ctx, idx) => Divider(
              color: Theme.of(context).dividerColor,
              thickness: 1.5,
              height: 20,
            ),
            itemBuilder: (BuildContext context, int index) {
              if (pb.articles.isEmpty) {
                if (pb.hasData) {
                  return LoadingCard(
                    height: 200,
                  );
                } else {
                  return _NoContents();
                }
              } else {
                return Card6(article: pb.articles[index], heroTag: 'popular${pb.articles[index].id}', scaffoldKey: scaffoldKey,);
              }
            },
          )
        ],
      ),
    );
  }
}



class _NoContents extends StatelessWidget {
  const _NoContents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
        child: Text(
          'Nothing to display',
          style: TextStyle(
              fontSize: 15,
              color: Theme.of(context)
                  .primaryColor,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
