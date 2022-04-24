import 'package:cached_network_image/cached_network_image.dart';
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


//Big card with title & description
class Card4 extends StatelessWidget {
  const Card4(
      {Key? key,
      required this.article,
      required this.heroTag,
      required this.scaffoldKey})
      : super(key: key);
  final Article article;
  final String heroTag;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final bookmarkedList = Hive.box(Constants.bookmarkTag);
    return InkWell(
      child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    /*Text(article.category!.toUpperCase(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500
                      ),
                    ),

                    SizedBox(height: 5),*/
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
                        Text("•"),
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
                        Spacer(),
                        BookmarkIcon(
                          bookmarkedList: bookmarkedList,
                          article: article,
                          iconSize: 18,
                          scaffoldKey: scaffoldKey,
                        )
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


