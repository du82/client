import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/constants.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/cached_image.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/bookmark_icon.dart';
import 'package:wordpress_app/widgets/video_icon.dart';


//small card with right sight image
class Card6 extends StatelessWidget {
  final Article article;
  final String heroTag;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const Card6(
      {Key? key,
        required this.article,
        required this.heroTag,
        required this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookmarkedList = Hive.box(Constants.bookmarkTag);

    return InkWell(
        child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppService.getNormalText(article.title!),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (article.content!.contains("Ad"))
                                Row(
                                  children: [
                                    Text(
                                      'Ad',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context)
                                              .primaryColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  'popular',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.w500),
                                ).tr(),
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
                                '${article.author}',
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
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                    fontWeight: FontWeight.w500),
                              ),
                              /*BookmarkIcon(
                            bookmarkedList: bookmarkedList,
                            article: article,
                            iconSize: 18,
                            scaffoldKey: scaffoldKey,
                          )*/
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
        onTap: () => navigateToDetailsScreen(context, article, heroTag)
    );
  }
}
