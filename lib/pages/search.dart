import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/src/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:wordpress_app/blocs/category_bloc.dart';
import 'package:wordpress_app/cards/card5.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/config/server_config.dart';
import 'package:wordpress_app/mini_program/devkit.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/category.dart';
import 'package:wordpress_app/models/constants.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import 'package:wordpress_app/utils/cached_image_with_dark.dart';
import 'package:wordpress_app/utils/empty_icon.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/utils/snacbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

import 'category_based_articles.dart';
import 'login.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var searchFieldCtrl = TextEditingController();
  bool _searchStarted = false;

  Future? data;

  get itemBuilder => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: _searchBar(),
        elevation: 0,
        leading: IconButton(
          icon: Padding(
            padding: const EdgeInsets.only(
                left: 5,
                right: 5
            ),
            child: Icon(
              LucideIcons.chevronLeft,
              size: 32,
            ),
          ),
          onPressed: ()=> Navigator.pop(context),
        ),
      ),
      key: scaffoldKey,

      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      _searchStarted == false
                          ? _suggestionUI()
                          : _afterSearchUI(),
                    ],
                  ),
                ),
              ),
              /*Material(
                elevation: 5,
                child: _bottomWidget(context),
              )*/
            ],
          ),
        ],
      ),


    );
  }

  Widget _searchBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Stack(
        children: [
          Container(
            height: 40,
            margin: EdgeInsets.only(right: 15, top: 5),
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryVariant,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              autofocus: true,
              maxLines: 1,
              maxLength: 100,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: searchFieldCtrl,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "search contents".tr(),
                counterText: "",
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                suffixIcon: IconButton(
                    padding: EdgeInsets.only(right: 10),
                    icon: Icon(
                      LucideIcons.delete,
                      size: 22,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchStarted = false;
                      });
                      searchFieldCtrl.clear();
                    }),
              ),
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (query) {
                if (query == '' || query.isEmpty) {
                  openSnacbar(scaffoldKey, 'Type something');
                } else {
                  setState(() => _searchStarted = true);
                  data = TenwanService().fetchPostsBySearch(searchFieldCtrl.text);
                  AppService().addToRecentSearchList(query);
                }
                if (query.contains("https://")) {
                  AppService().openLinkWithBrowserMiniProgram(
                      context, query);
                } else if (query.contains("http://")) {
                  AppService().openLinkWithBrowserMiniProgram(
                      context, query);
                } else if (query.contains("//devkit")) {
                  Navigator.of(context).push(SwipeablePageRoute(
                      builder: (BuildContext context) => DevKitMiniProgram()),
                  );
                } else if (query.startsWith("!d ")) {
                  AppService().openLinkWithBrowserMiniProgram(
                      context, ("https://duckduckgo.com/?q=" + query.replaceRange(0, 2, "")));
                } else if (query.startsWith("!w ")) {
                  AppService().openLinkWithBrowserMiniProgram(
                      context, ("https://wikipedia.org/wiki/" + query.replaceRange(0, 2, "")));
                } else if (query.startsWith("!y ")) {
                  AppService().openLinkWithBrowserMiniProgram(
                      context, ("https://www.youtube.com/results?search_query=" + query.replaceRange(0, 2, "")));
                } else if (query.startsWith("!o ")) {
                  AppService().openLinkWithBrowserMiniProgram(
                      context, ("https://odysee.com/\$/search?q=" + query.replaceRange(0, 2, "")));
                } else if (query.startsWith("!mp ")) {
                  AppService().openLinkWithRenderMiniProgram(
                      context, (query.replaceRange(0, 3, "")));
                } else {
                  if (query.contains(".com") ||
                      query.contains(".net") ||
                      query.contains(".org") ||
                      query.contains(".dev") ||
                      query.contains(".gov") ||
                      query.contains(".xyz") ||
                      query.contains(".xyz") ||
                      query.contains(".io") ||
                      query.contains(".me") ||
                      query.contains(".im") ||
                      query.contains(".co") ||
                      query.contains(".cn")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://" + query));
                  }
                }
              },
            ),
          ),
        ],
      )
    );
  }

  Widget _afterSearchUI() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: data,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return _LoadingWidget();
                case ConnectionState.done:
                default:
                  if (snapshot.hasError || snapshot.data == null) {
                    return EmptyPageWithIcon(
                        icon: Icons.error, title: 'Error!');
                  } else if (snapshot.data.isEmpty) {
                    return EmptyPageWithImage(
                      image: Config.noContentImage,
                      title: 'no contents found'.tr(),
                      description: 'try again'.tr(),
                    );
                  }

                  return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      separatorBuilder: (ctx, idx) => Divider(
                        color: Theme.of(context).dividerColor,
                        thickness: 1.5,
                        height: 20,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        Article article = snapshot.data[index];
                        return Card5(
                            article: article,
                            heroTag: 'search${article.id}',
                            scaffoldKey: scaffoldKey);
                      });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _suggestionUI() {
    final recentSearchs = Hive.box(Constants.resentSearchTag);
    final d = context.watch<CategoryBloc>().categoryData;
    return recentSearchs.isEmpty
        ? _EmptySearchAnimation()
        : Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              /*margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10),*/
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'recent searches'.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
                ),
                ValueListenableBuilder(
                  valueListenable: recentSearchs.listenable(),
                  builder: (BuildContext context, dynamic value, Widget? child) {
                    return ListView.separated(
                      itemCount: recentSearchs.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                              horizontalTitleGap: 5,
                              title: Text(
                                recentSearchs.getAt(index),
                                style: TextStyle(fontSize: 17),
                              ),
                              trailing: IconButton(
                                icon: Icon(LucideIcons.trash2),
                                onPressed: () => AppService()
                                    .removeFromRecentSearchList(index),
                              ),
                              onTap: () {
                                setState(() => _searchStarted = true);
                                searchFieldCtrl.text =
                                    recentSearchs.getAt(index);
                                data = TenwanService()
                                    .fetchPostsBySearch(searchFieldCtrl.text);
                              }),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
        itemBuilder: (BuildContext context, int index) {
          return LoadingCard(height: 110);
        });
  }
}

class _EmptySearchAnimation extends StatelessWidget {
  const _EmptySearchAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
        ),

        Text('search for contents', style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.7,
          wordSpacing: 1
        ),).tr(),

        SizedBox(height: 10,),

        Text('search-description', 
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.secondary
        ),).tr(),
      ],
    );
  }
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Hero(
              tag: _heroTag,
              child: CustomCacheImageWithDarkFilterBottom(
                imageUrl: _thumbnail,
                radius: 8,
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