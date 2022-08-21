import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
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
import '../cards/search_cards/search_hint_qrcode.dart';

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
  ScrollController _scrollController = new ScrollController();

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
          elevation: 0.2,
          toolbarHeight: 40,
          centerTitle: false,
          automaticallyImplyLeading: false,
          titleSpacing: 20,
          /*leading: InkWell(
            child: IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(
                    left: 0,
                    right: 0
                ),
                child: Icon(
                  LucideIcons.chevronLeft,
                  size: 25,
                ),
              ), onPressed: () {Navigator.pop(context);},
            ),
            onLongPress: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),*/
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover, image: CachedNetworkImageProvider(
                      article!.avatar!)),
                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
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
                              fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          article.timeAgo!,
                          style: TextStyle(
                              fontSize: 12,
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
              Container(width: 8,),
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 22,
                  //width: 100,
                  decoration: BoxDecoration(
                    //color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                      color: Config().appThemeColor,
                      borderRadius: BorderRadius.circular(6)
                  ),
                  child: Center(
                    child: Text(
                      'follow',
                      maxLines: 1,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          letterSpacing: -0.7,
                          wordSpacing: 1,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.background,
                          fontWeight: FontWeight.w500),
                    ).tr(),
                  ),
                ),
                onTap: () => nextScreen(
                    context, CommentsPage(postId: article.id, categoryId: article.catId!,)),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                /*IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: Icon(
                      LucideIcons.headphones,
                      size: 20,
                    ),
                  ),
                  onPressed: () {Navigator.pop(context);},
                ),*/
                InkWell(
                  child: IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(
                          right: 15
                      ),
                      child: Icon(
                        LucideIcons.moreVertical,
                        size: 20,
                      ),
                    ),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: false,
                        backgroundColor: Theme.of(context).colorScheme.onSecondary,
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                            color: Theme.of(context).colorScheme.onSecondary,
                            margin: EdgeInsets.only(top: 12),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 10),
                                      child: SearchHintQRcode()),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  onLongPress: () => Navigator.of(context).popUntil((route) => route.isFirst),
                ),
              ],
            )
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 45,
          child: BottomAppBar(
            color: Theme.of(context).backgroundColor,
            child: Row(
              children: [
                InkWell(
                  child: IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(
                          left: 0,
                          right: 0
                      ),
                      child: SvgPicture.asset('assets/icons/left.svg', width: 30,),
                    ), onPressed: () {Navigator.pop(context);},
                  ),
                  onLongPress: () => Navigator.of(context).popUntil((route) => route.isFirst),
                ),
                //SizedBox(width: 8),
                Flexible(
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 20),
                      height: 30,
                      width: MediaQuery.of(context).size.width - 200,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                              'assets/icons/write.svg',
                              color: Theme.of(context).colorScheme.secondary,
                              width: 20,
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              'comment',
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
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                              child: CommentsPage(postId: article.id, categoryId: article.catId!,),
                            margin: EdgeInsets.only(top: 18),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(width: 10),
                Row(
                  children: [
                    IconButton(
                      icon: Padding(
                        padding: const EdgeInsets.only(
                            left: 0,
                            right: 0
                        ),
                        child: SvgPicture.asset(
                            'assets/icons/chat.svg'),
                      ),
                      onPressed: () => _scrollController.animateTo(
                        5000,
                        curve: Curves.easeOut,
                        duration: const Duration(seconds: 2),
                      )
                    ),
                    Container(
                      margin: new EdgeInsets.symmetric(horizontal: 5),
                      child: BookmarkIcon(
                        bookmarkedList: bookmarkedList,
                        article: article,
                        iconSize: 30,
                        scaffoldKey: scaffoldKey,
                        normalIconColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      icon: Padding(
                        padding: const EdgeInsets.only(
                            left: 5
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/share.svg'),
                      ),
                      onPressed: ()=> _handleShare(),
                    ),
                  ],
                ),
              ],
            ),
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
                  controller: _scrollController,
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
                                  AppService.getNormalText(article.title!),
                                  style: TextStyle(
                                      fontSize: 25,
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
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Text(
                                  'comments',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 23, fontWeight: FontWeight.w700),
                                ).tr(),
                                Spacer(),
                                InkWell(
                                  child: Container(
                                    height: 25,
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    margin: EdgeInsets.only(left: 5, top: 5, right: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Center(
                                      child: Text(
                                        'scroll to top',
                                        maxLines: 1,
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            letterSpacing: -0.7,
                                            wordSpacing: 1,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ).tr(),
                                    ),
                                  ),
                                  onTap: () => _scrollController.animateTo(
                                    0,
                                    curve: Curves.easeOut,
                                    duration: const Duration(milliseconds: 1000),
                                  )
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height - 170,
                            child: CommentsPage(postId: article.id, categoryId: article.catId!,),
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
