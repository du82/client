import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/category_bloc.dart';
import 'package:wordpress_app/config/server_config.dart';
import 'package:wordpress_app/models/category.dart';
import 'package:wordpress_app/pages/category_based_articles.dart';
import 'package:wordpress_app/pages/search.dart';
import 'package:wordpress_app/utils/cached_image_with_dark.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/utils/vertical_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordpress_app/widgets/lattest_articles.dart';

class SearchTab extends StatefulWidget {

  const SearchTab({Key? key, required this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final d = context.watch<CategoryBloc>().categoryData;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async => await context.read<CategoryBloc>().fetchData(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height - 150,
              toolbarHeight: 0,
              elevation: 0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  /*decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),*/
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        margin: EdgeInsets.only(left: 30, right: 30, bottom: 0, top: 0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.contain, image: CachedNetworkImageProvider("https://bankingthefuture.com/wp-content/uploads/2019/04/dummylogo.jpg")),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              left: 30, right: 30, bottom: 30),
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background.withOpacity(1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(1),
                                width: 2
                              )
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.search,
                                color: Colors.grey[600],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'search for contents',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600]),
                              ).tr(),
                            ],
                          ),
                        ),
                        onTap: () => nextScreen(context, SearchPage()),
                      ),
                      Text(
                        'Swipe up for news',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          //color: Colors.white,
                        ),
                      ).tr(),
                      Container(
                        height: 90,
                      ),

                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                  padding:
                  EdgeInsets.only(bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          LucideIcons.chevronUp
                      ),
                      Text(
                        'Swipe up for news',
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                  padding:
                      EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LattestArticles(scaffoldKey: widget.scaffoldKey),
                    ],
                  )
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                  padding:
                  EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          verticalLine(context, 20),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'categories',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ).tr(),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              top: 5, bottom: 20, left: 0, right: 0),
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1.3),
                          itemCount: d.isEmpty ? 10 : d.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (d.length == 0)
                              return LoadingCard(
                                height: null,
                              );

                            return _CategoryItem(
                              d: d[index],
                            );
                          },
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _CategoryItem extends StatelessWidget {
  final Category d;
  const _CategoryItem({Key? key, required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final String _heroTag = 'category${d.id}';
    final String _thumbnail = WpConfig.categoryThumbnails.keys.contains(d.id)
        ? WpConfig.categoryThumbnails[d.id]
        : WpConfig.randomCategoryThumbnail;

    return InkWell(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Hero(
              tag: _heroTag,
              child: CustomCacheImageWithDarkFilterBottom(
                imageUrl: _thumbnail,
                radius: 5,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${d.name!.toUpperCase()}",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      onTap: () {
        nextScreen(
            context,
            CategoryBasedArticles(
              categoryName: d.name,
              categoryId: d.id,
              categoryThumbnail: _thumbnail,
              heroTag: _heroTag,
            ));
      },
    );
  }
}
