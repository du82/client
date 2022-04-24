import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:share/share.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/constants.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/cached_image.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/bookmark_icon.dart';
import 'package:wordpress_app/widgets/video_icon.dart';


//Big card with title & description
class Card2 extends StatelessWidget {
  const Card2(
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

  Future _handleShare(String s) async {
    var widget;
    Share.share(widget.articleData!.link!);
  }

  Future _handleReport() async {
    AppService().openEmailSupport(Uri());
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkedList = Hive.box(Constants.bookmarkTag);
    return InkWell(
        child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppService.getNormalText(article.title!),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: Hero(
                              tag: heroTag,
                              child: CustomCacheImage(
                                  imageUrl: article.image, radius: 0))),
                    ),
                    VideoIcon(tags: article.tags, iconSize: 60,)
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 8,
                            backgroundImage: CachedNetworkImageProvider(
                                article.avatar!),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${article.author}',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 3,
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
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            article.timeAgo!,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          if (article.content!.contains("Ad"))
                            Row(
                              children: [
                                Text(
                                  '•',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  'Ad',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          else
                            Container(),
                          Spacer(),
                          IconButton(
                            padding: EdgeInsets.only(right: 0, left: 8),
                            constraints: BoxConstraints(),
                            icon: Icon(
                              Feather.x,
                              size: 18,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: () {
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
                                  return Container(
                                    height: 300,
                                    //color: Colors.amber,

                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const Text('Modal BottomSheet'),
                                          ElevatedButton(
                                            child: const Text('Close BottomSheet'),
                                            onPressed: () => Navigator.pop(context),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
        onTap: () => navigateToDetailsScreen(context, article, heroTag)
    );
  }
}


