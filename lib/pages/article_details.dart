import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive/hive.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share/share.dart';
import 'package:wordpress_app/blocs/ads_bloc.dart';
import 'package:wordpress_app/config/ad_config.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/models/constants.dart';
import 'package:wordpress_app/pages/comments_page.dart';
import 'package:wordpress_app/pages/search.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/banner_ad.dart';
import 'package:wordpress_app/widgets/bookmark_icon.dart';
import 'package:wordpress_app/widgets/full_image.dart';
import 'package:wordpress_app/widgets/local_video_player.dart';
import 'package:wordpress_app/widgets/related_articles.dart';
import '../models/article.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../utils/cached_image.dart';

class ArticleDetails extends StatefulWidget {
  final String? tag;
  final Article? articleData;

  ArticleDetails({Key? key, this.tag, required this.articleData})
      : super(key: key);

  @override
  _ArticleDetailsState createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  double _rightPaddingValue = 140;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  get heroTag => null;

  Future _handleShare() async {
    Share.share(widget.articleData!.link!);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0))
        .then((value) => context.read<AdsBloc>().showLoadedAds());
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        _rightPaddingValue = 10;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Article? article = widget.articleData;
    final bookmarkedList = Hive.box(Constants.bookmarkTag);

    return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).backgroundColor,
          child: Row(
            children: [
              InkWell(
                child: IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.only(
                        left: 5,
                        right: 0
                    ),
                    child: Icon(
                      LucideIcons.chevronLeft,
                      size: 32,
                    ),
                  ), onPressed: () {Navigator.pop(context);},
                ),
                onLongPress: () => Navigator.of(context).popUntil((route) => route.isFirst),
              ),
              SizedBox(width: 8),
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 20),
                  height: 35,
                  width: MediaQuery.of(context).size.width - 200,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        LucideIcons.edit3,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'write a comment',
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.clip,
                              letterSpacing: -0.7,
                              wordSpacing: 1,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500),
                        ).tr(),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  showModalBottomSheet<void>(
                    backgroundColor: Colors.white,
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18)
                      ),
                    ),
                    builder: (BuildContext context) {
                      return CommentsPage(postId: article!.id, categoryId: article.catId!,);
                    },
                  );
                },
              ),
              SizedBox(width: 10),
              Row(
                children: [
                  Container(
                    margin: new EdgeInsets.symmetric(horizontal: 5),
                    child: BookmarkIcon(
                      bookmarkedList: bookmarkedList,
                      article: article,
                      iconSize: 24,
                      scaffoldKey: scaffoldKey,
                      iconColor: Theme.of(context).primaryColor,
                      normalIconColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(
                          left: 5,
                          right: 0
                      ),
                      child: Icon(
                        LucideIcons.search,
                        size: 25,
                      ),
                    ),
                    onPressed: () => nextScreen(context, SearchPage()),
                  ),
                  IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(
                          left: 5,
                          right: 8
                      ),
                      child: Icon(
                        LucideIcons.cornerUpRight,
                        size: 25,
                      ),
                    ),
                    onPressed: ()=> _handleShare(),
                  ),
                ],
              ),

            ],
          ),
        ),
        body: SafeArea(
          bottom: true,
          top: false,
          maintainBottomViewPadding: true,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                /*Container(
                                  height: MediaQuery.of(context).size.width / 2.5,
                                  width: double.infinity,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      child: CustomCacheImage(
                                          imageUrl: article?.image, radius: 0)),
                                ),
                                SizedBox(height: 10),*/
                                Text(
                                  AppService.getNormalText(article!.title!),
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      //letterSpacing: -0.6,
                                      wordSpacing: 1),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(0),
                                  child: Column(
                                    children: [
                                      Divider(
                                        color: Theme.of(context).dividerColor,
                                        thickness: 1.5,
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 45,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover, image: CachedNetworkImageProvider(
                                                  article.avatar!)),
                                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  //mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${article.author}',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w800),
                                                    ),
                                                    Row(
                                                      children: [
                                                        if (article.author!.contains("白石AI"))
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '•',
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Theme.of(context).colorScheme.secondary,
                                                                    fontWeight: FontWeight.w500),
                                                              ),
                                                              Text(
                                                                'Verified AI writer',
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Theme.of(context).primaryColor,
                                                                    fontWeight: FontWeight.w500),
                                                              ),
                                                            ],
                                                          )
                                                        else
                                                          Container(),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  //mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      article.timeAgo!,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    Text(
                                                      '•',
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    Text(
                                                      article.category!,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            child: Container(
                                              padding: EdgeInsets.only(left: 8, right: 12),
                                              height: 35,
                                              //width: 100,
                                              decoration: BoxDecoration(
                                                //color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                                                  color: Config().appThemeColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    LucideIcons.plusCircle,
                                                    color: Theme.of(context).colorScheme.background,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    'follow',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        overflow: TextOverflow.ellipsis,
                                                        letterSpacing: -0.7,
                                                        wordSpacing: 1,
                                                        fontSize: 16,
                                                        color: Theme.of(context).colorScheme.background,
                                                        fontWeight: FontWeight.w500),
                                                  ).tr(),
                                                ],
                                              ),
                                            ),
                                            onTap: () => nextScreen(
                                                context, CommentsPage(postId: article.id, categoryId: article.catId!,)),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Theme.of(context).dividerColor,
                                        thickness: 1.5,
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                Html(
                                  data: article.content,
                                  onLinkTap: (String? url,
                                      RenderContext context1,
                                      Map<String, String> attributes,
                                      _) {
                                    if (url!.endsWith("?mp=render")) {
                                      AppService().openLinkWithRenderMiniProgram(context, url);
                                    } else {
                                      AppService().openLinkWithBrowserMiniProgram(context, url);
                                    }
                                  },
                                  onImageTap: (String? url,
                                      RenderContext context1,
                                      Map<String, String> attributes,
                                      _) {
                                    nextScreen(context, FullScreenImage(imageUrl: url!));
                                  },
                                  style: {
                                    "body": Style(
                                    margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                fontSize: FontSize(17.0),
                                lineHeight: LineHeight(1.3),
                                whiteSpace: WhiteSpace.NORMAL,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.primary,
                                fontFamily: ''),
                                    "figure": Style(
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.zero,
                                    ),
                                  },
                                  customRender: {
                                    "video":
                                        (RenderContext context1, Widget child) {
                                      return LocalVideoPlayer(
                                          videoUrl: context1
                                              .tree.element!.attributes['src']
                                              .toString());
                                    },
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: AdConfig.isAdsEnabled == true ? BannerAdWidget() : Container(),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Divider(
                              color: Theme.of(context).dividerColor,
                              thickness: 1.5,
                              height: 20,
                            ),
                          ),
                          RelatedArticles(
                            postId: article.id,
                            catId: article.catId,
                            scaffoldKey: scaffoldKey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // banner ads
            ],
          ),
        ));
  }
}
