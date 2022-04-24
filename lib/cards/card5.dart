import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/cached_image.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/video_icon.dart';


//card for related articles in the details page
class Card5 extends StatelessWidget {
  const Card5({Key? key,
    required this.article,
    required this.scaffoldKey,
    required this.heroTag})
      : super(key: key);
  final Article article;
  final String heroTag;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    //final bookmarkedList = Hive.box(Constants.bookmarkTag);
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  //height: 120,
                  padding: EdgeInsets.only(top: 0, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppService.getNormalText(article.title!),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      // Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundImage: CachedNetworkImageProvider(
                                article.avatar!),
                          ),
                          SizedBox(
                            width: 5,
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
                          Text("•"),
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
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  /*Container(
                      height: 100,
                      width: 150,
                      child: CustomCacheImage(imageUrl: article.image, radius: 8)
                  ),*/
                  Container(
                    height: 100,
                    width: 150,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Hero(
                            tag: heroTag,
                            child: CustomCacheImage(
                                imageUrl: article.image, radius: 0)
                        )
                    ),
                  ),

                  VideoIcon(tags: article.tags, iconSize: 40,)
                ],
              ),
              /*SizedBox(
                width: 10,
              ),*/
            ],
          )),
      onTap: () => navigateToDetailsScreenByReplace(context, article, null)
    );
  }
}
