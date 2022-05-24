import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/src/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:wordpress_app/blocs/category_bloc.dart';
import 'package:wordpress_app/cards/card5.dart';
import 'package:wordpress_app/config/server_config.dart';
import 'package:wordpress_app/mini_program/devkit.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/category.dart';
import 'package:wordpress_app/models/constants.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import 'package:wordpress_app/utils/cached_image_with_dark.dart';
import 'package:wordpress_app/utils/empty_icon.dart';
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

  get query => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: _searchBar(),
        elevation: 0,
        leadingWidth: 15,
        leading: Container(),
        /*leading: IconButton(
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
        ),*/
      ),
      key: scaffoldKey,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                ),
                child: Icon(
                  Feather.chevron_left,
                  size: 32,
                ),
              ),
              onPressed: ()=> Navigator.pop(context),
            ),
          ],
        ),
      ),
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
                  suffixIcon: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(left: 8, top: 10, right: 10, bottom: 8),
                      alignment: Alignment.center,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Text(
                          'Go',
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: -0.7,
                              wordSpacing: 1,
                              fontSize: 16,
                              color: Theme.of(context).backgroundColor,
                              fontWeight: FontWeight.w500),
                        ).tr(),
                      ),
                    ),

                    onTap: (){
                      AppService().addToRecentSearchList(searchFieldCtrl.text);
                      if (searchFieldCtrl.text.contains("https://")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, searchFieldCtrl.text);
                      } else if (searchFieldCtrl.text.contains("http://")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, searchFieldCtrl.text);
                      } else if (searchFieldCtrl.text.contains("//devkit")) {
                        Navigator.of(context).push(SwipeablePageRoute(
                            builder: (BuildContext context) => DevKitMiniProgram()),
                        );
                        // B - Baidu
                      } else if (searchFieldCtrl.text.startsWith("!bd ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://www.baidu.com/s?wd=" + searchFieldCtrl.text.replaceRange(0, 3, "")));
                        // D - DuckDuckGo
                      } else if (searchFieldCtrl.text.startsWith("!d ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://duckduckgo.com/?q=" + searchFieldCtrl.text.replaceRange(0, 2, "")));
                        // G - GitHub
                      } else if (searchFieldCtrl.text.startsWith("!gh ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://github.com/search?q=" + searchFieldCtrl.text.replaceRange(0, 3, "")));
                        // T - Toutiao
                      } else if (searchFieldCtrl.text.startsWith("!t ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://so.toutiao.com/search?keyword=" + searchFieldCtrl.text.replaceRange(0, 2, "")));
                        // O - Odysee
                      } else if (searchFieldCtrl.text.startsWith("!o ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://odysee.com/\$/search?q=" + searchFieldCtrl.text.replaceRange(0, 2, "")));
                        // S - SearXNG
                      } else if (searchFieldCtrl.text.startsWith("!s ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://s.zhaocloud.net/search?q=" + searchFieldCtrl.text.replaceRange(0, 2, "")));
                        // SO - Stack Overflow
                      } else if (searchFieldCtrl.text.startsWith("!so ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://stackoverflow.com/search?q=" + searchFieldCtrl.text.replaceRange(0, 3, "")));
                        // W - Wikipedia
                      } else if (searchFieldCtrl.text.startsWith("!w ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://wikipedia.org/wiki/" + searchFieldCtrl.text.replaceRange(0, 2, "")));
                      } else if (searchFieldCtrl.text.startsWith("!wa ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://www.wolframalpha.com/input?i=" + searchFieldCtrl.text.replaceRange(0, 3, "")));
                        // X - Xigua Video
                      } else if (searchFieldCtrl.text.startsWith("!x ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://www.ixigua.com/search/" + searchFieldCtrl.text.replaceRange(0, 2, "")));
                        // Y - YouTube
                      } else if (searchFieldCtrl.text.startsWith("!yt ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://www.youtube.com/results?search_query=" + searchFieldCtrl.text.replaceRange(0, 3, "")));

                      } else if (searchFieldCtrl.text.startsWith("!mp ")) {
                        AppService().openLinkWithRenderMiniProgram(
                            context, (searchFieldCtrl.text.replaceRange(0, 3, "")));
                      } else {
                        if (searchFieldCtrl.text.contains(".com") ||
                            searchFieldCtrl.text.contains(".net") ||
                            searchFieldCtrl.text.contains(".org") ||
                            searchFieldCtrl.text.contains(".dev") ||
                            searchFieldCtrl.text.contains(".gov") ||
                            searchFieldCtrl.text.contains(".xyz") ||
                            searchFieldCtrl.text.contains(".xyz") ||
                            searchFieldCtrl.text.contains(".io") ||
                            searchFieldCtrl.text.contains(".me") ||
                            searchFieldCtrl.text.contains(".im") ||
                            searchFieldCtrl.text.contains(".co") ||
                            searchFieldCtrl.text.contains(".cn")) {
                          AppService().openLinkWithBrowserMiniProgram(
                              context, ("https://" + searchFieldCtrl.text));
                        }
                      }
                      setState(() => _searchStarted = true);
                      data = TenwanService().fetchPostsBySearch(searchFieldCtrl.text);},
                  ),
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
                    // B - Baidu
                  } else if (query.startsWith("!bd ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://www.baidu.com/s?wd=" + query.replaceRange(0, 3, "")));
                    // D - DuckDuckGo
                  } else if (query.startsWith("!d ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://duckduckgo.com/?q=" + query.replaceRange(0, 2, "")));
                    // G - GitHub
                  } else if (query.startsWith("!gh ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://github.com/search?q=" + query.replaceRange(0, 3, "")));
                    // T - Toutiao
                  } else if (query.startsWith("!t ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://so.toutiao.com/search?keyword=" + query.replaceRange(0, 2, "")));
                    // O - Odysee
                  } else if (query.startsWith("!o ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://odysee.com/\$/search?q=" + query.replaceRange(0, 2, "")));
                    // S - SearXNG
                  } else if (query.startsWith("!s ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://s.zhaocloud.net/search?q=" + query.replaceRange(0, 2, "")));
                    // SO - Stack Overflow
                  } else if (query.startsWith("!so ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://stackoverflow.com/search?q=" + query.replaceRange(0, 3, "")));
                    // W - Wikipedia
                  } else if (query.startsWith("!w ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://wikipedia.org/wiki/" + query.replaceRange(0, 2, "")));
                  } else if (query.startsWith("!wa ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://www.wolframalpha.com/input?i=" + query.replaceRange(0, 3, "")));
                    // X - Xigua Video
                  } else if (query.startsWith("!x ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://www.ixigua.com/search/" + query.replaceRange(0, 2, "")));
                    // Y - YouTube
                  } else if (query.startsWith("!yt ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://www.youtube.com/results?search_query=" + query.replaceRange(0, 3, "")));

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
                    return _searchProviderUI();
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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'recent searches'.tr(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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

  Widget _searchProviderUI() {
    final recentSearchs = Hive.box(Constants.resentSearchTag);
    final d = context.watch<CategoryBloc>().categoryData;
    return recentSearchs.isEmpty
        ? _EmptySearchAnimation()
        : Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'try alt search'.tr(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(
                left: 10, right: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: CachedNetworkImageProvider("https://duckduckgo.com/favicon.ico")),
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                  ),
                  title: Text(
                    'duck duck go',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  trailing: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 25,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Text(
                          '!d',
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: -0.7,
                              wordSpacing: 1,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500),
                        ).tr(),
                      ),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "!d ";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(
                left: 10, right: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: CachedNetworkImageProvider(WpConfig.websiteUrl + "/app-content/icons/odysee.png")),
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                  ),
                  title: Text(
                    'odysee',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  trailing: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 25,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Text(
                          '!o',
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: -0.7,
                              wordSpacing: 1,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500),
                        ).tr(),
                      ),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "!o ";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(
                left: 10, right: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: CachedNetworkImageProvider("https://github.com/favicon.ico")),
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                  ),
                  title: Text(
                    'github',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  trailing: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 25,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Text(
                          '!gh',
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: -0.7,
                              wordSpacing: 1,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500),
                        ).tr(),
                      ),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "!gh ";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(
                left: 10, right: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: CachedNetworkImageProvider("https://s.zhaocloud.net/favicon.ico")),
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                  ),
                  title: Text(
                    'searxng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  trailing: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 25,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Text(
                          '!s',
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: -0.7,
                              wordSpacing: 1,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500),
                        ).tr(),
                      ),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "!s ";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(
                left: 10, right: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: CachedNetworkImageProvider("https://en.wikipedia.org/favicon.ico")),
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                  ),
                  title: Text(
                    'wikipedia',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  trailing: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 25,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Text(
                          '!w',
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: -0.7,
                              wordSpacing: 1,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500),
                        ).tr(),
                      ),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "!w ";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(
                left: 10, right: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: CachedNetworkImageProvider("https://www.wolframalpha.com/favicon.ico")),
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                  ),
                  title: Text(
                    'wolfram alpha',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  trailing: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 25,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Text(
                          '!wa',
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: -0.7,
                              wordSpacing: 1,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500),
                        ).tr(),
                      ),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "!wa ";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(
                left: 10, right: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: CachedNetworkImageProvider(WpConfig.websiteUrl + "/app-content/icons/baidu.png")),
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                  ),
                  title: Text(
                    'baidu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  trailing: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 25,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Text(
                          '!bd',
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: -0.7,
                              wordSpacing: 1,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500),
                        ).tr(),
                      ),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "!bd ";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(
                left: 10, right: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: CachedNetworkImageProvider(WpConfig.websiteUrl + "/app-content/icons/youtube.png")),
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                  ),
                  title: Text(
                    'youtube',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  trailing: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 25,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Text(
                          '!yt',
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: -0.7,
                              wordSpacing: 1,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500),
                        ).tr(),
                      ),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "!yt ";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(
                left: 10, right: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: CachedNetworkImageProvider("https://baishi.io/favicon.ico")),
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                  ),
                  title: Text(
                    'Baishi Mini Programs',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  trailing: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 25,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Text(
                          '!mp',
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: -0.7,
                              wordSpacing: 1,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500),
                        ).tr(),
                      ),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "!mp ";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
              ],
            ),
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

class _Divider extends StatelessWidget {
  const _Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.0,
      thickness: 0.2,
      indent: 50,
      color: Colors.grey[400],
    );
  }
}