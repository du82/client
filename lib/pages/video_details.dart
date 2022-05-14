import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:share/share.dart';
import 'package:wordpress_app/blocs/ads_bloc.dart';
import 'package:wordpress_app/config/ad_config.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/mini_program/browser.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/constants.dart';
import 'package:wordpress_app/pages/search.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/banner_ad.dart';
import 'package:wordpress_app/widgets/bookmark_icon.dart';
import 'package:wordpress_app/widgets/full_image.dart';
import 'package:wordpress_app/widgets/local_video_player.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/widgets/related_articles.dart';
import 'comments_page.dart';

class VideoDetails extends StatefulWidget {
  const VideoDetails({Key? key, required this.article})
      : super(key: key);

  final Article article;

  @override
  _VideoDetailsState createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  double _rightPaddingValue = 140;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future _handleShare() async {
    Share.share(widget.article.link!);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) => context.read<AdsBloc>().showLoadedAds());
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        _rightPaddingValue = 10;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Article? article = widget.article;
    final bookmarkedList = Hive.box(Constants.bookmarkTag);

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        key: scaffoldKey,
        appBar: _appBar(),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).backgroundColor,
          child: Row(
            children: [
              IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Icon(
                    Feather.chevron_left,
                    size: 32,
                  ),
                ),
                onPressed: ()=> Navigator.pop(context),
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
                        Feather.edit_3,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'write a comment',
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
              Container(
                margin: new EdgeInsets.symmetric(horizontal: 5),
                child: BookmarkIcon(
                  bookmarkedList: bookmarkedList,
                  article: article,
                  iconSize: 25,
                  scaffoldKey: scaffoldKey,
                  iconColor: Colors.redAccent,
                  normalIconColor: Colors.black,
                ),
              ),
              IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(
                      left: 5,
                      right: 5
                  ),
                  child: Icon(
                    Feather.search,
                    size: 24,
                  ),
                ),
                onPressed: () => nextScreen(context, SearchPage()),
              ),
              IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(
                      left: 0,
                      right: 5
                  ),
                  child: Icon(
                    Feather.corner_up_right,
                    size: 25,
                  ),
                ),
                onPressed: ()=> _handleShare(),
              ),
            ],
          ),
        ),
        body: SafeArea(
          bottom: true,
          child: Column(
            children: [
              Container(
                child: Html(
                  shrinkWrap: true,
                  data: article!.content,
                  tagsList: const ['html', 'body', 'figure', 'video'],
                  style: {
                    "body": Style(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      fontSize: FontSize(17.0),
                      lineHeight: LineHeight(1.4),
                    ),
                    "figure": Style(margin: EdgeInsets.zero, padding: EdgeInsets.zero),
                  },
                  customRender: {
                    "video": (RenderContext context1, Widget child) {
                      return LocalVideoPlayer(
                          videoUrl: context1.tree.element!.attributes['src']
                              .toString());
                    },
                  },
                ),
              ),
              Container(
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                AppService.getNormalText(article.title!),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    //letterSpacing: -0.6,
                                    wordSpacing: 1),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                color: Theme.of(context).dividerColor,
                                thickness: 1.5,
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  /*CircleAvatar(
                                    radius: 20,
                                    backgroundImage: CachedNetworkImageProvider(
                                        article.avatar!),
                                  ),*/
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
                                          borderRadius: BorderRadius.circular(100)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Feather.plus_circle,
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

                                    //onTap: ()=> nextScreen(context, SearchPage()),
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
                ),
              ),

              // banner ads
            ],
          ),
        ));
  }
  AppBar _appBar() {
    return AppBar(
      /*systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.black, // For both Android + iOS
        // Status bar brightness
        statusBarIconBrightness: Brightness.light, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      automaticallyImplyLeading: false,
      toolbarHeight: 0,
      leading: Container(),*/
      flexibleSpace: Container(color: Colors.black, height: 50,),
      toolbarHeight: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
  }
}