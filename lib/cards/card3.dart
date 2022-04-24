import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:share/share.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/constants.dart';
import 'package:wordpress_app/pages/comments_page.dart';
import 'package:wordpress_app/pages/search.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/cached_image.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/bookmark_icon.dart';
import 'package:wordpress_app/widgets/local_video_player.dart';
import 'package:wordpress_app/widgets/video_icon.dart';


//Big card with title & description
class Card3 extends StatelessWidget {
  const Card3(
      {Key? key,
        required this.article,
        required this.heroTag,
        required this.scaffoldKey})
      : super(key: key);
  final Article article;
  final String heroTag;
  final GlobalKey<ScaffoldState> scaffoldKey;

  Future _handleBookmark(Box<dynamic> bookmarkedList) async {
    BookmarkIcon(
      bookmarkedList: bookmarkedList,
      article: article,
      iconSize: 18,
      scaffoldKey: scaffoldKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkedList = Hive.box(Constants.bookmarkTag);
    return InkWell(
      child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: 15),
                child: Text(
                  AppService.getNormalText(article.title!),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    //height: 240,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      child: Container(
                        child: Html(
                          shrinkWrap: true,
                          data: article.content,
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
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Spacer(),
                        BookmarkIcon(
                          bookmarkedList: bookmarkedList,
                          article: article,
                          iconSize: 25,
                          scaffoldKey: scaffoldKey,
                          iconColor: Colors.redAccent,
                          normalIconColor: Colors.black,
                        ),
                        Spacer(),
                        IconButton(
                          icon: Padding(
                            padding: const EdgeInsets.only(
                                left: 5,
                                right: 5
                            ),
                            child: Icon(
                              Feather.message_square,
                              size: 24,
                            ),
                          ),
                          onPressed: () => nextScreen(context, CommentsPage(postId: article.id, categoryId: article.catId!,)),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Padding(
                            padding: const EdgeInsets.only(
                                left: 5,
                                right: 5
                            ),
                            child: Icon(
                              Feather.corner_up_right,
                              size: 24,
                            ),
                          ),
                          onPressed: () => nextScreen(context, SearchPage()),
                        ),
                        Spacer(),
                        InkWell(
                            child: Container(
                              padding: EdgeInsets.only(left: 12, right: 4),
                              height: 30,
                              //width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(width: 2, color: Config().appThemeColor),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Watch more',
                                    maxLines: 1,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        letterSpacing: -0.7,
                                        wordSpacing: 1,
                                        fontSize: 16,
                                        //color: Theme.of(context).colorScheme.background,
                                        fontWeight: FontWeight.w500),
                                  ).tr(),
                                  SizedBox(width: 10),
                                  Icon(
                                    Feather.arrow_right_circle,
                                    color: Config().appThemeColor,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            //onTap: ()=> nextScreen(context, SearchPage()),
                            onTap: () => navigateToDetailsScreen(context, article, heroTag)),
                        SizedBox(
                          width: 10,
                        ),
                        /*BookmarkIcon(
                            bookmarkedList: bookmarkedList,
                            article: article,
                            iconSize: 18,
                            scaffoldKey: scaffoldKey,
                          ),*/
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
      //onTap: () => navigateToDetailsScreen(context, article, heroTag)
    );
  }
}


