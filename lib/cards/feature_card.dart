import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/cached_image.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/video_icon.dart';


class FeatureCard extends StatelessWidget {
  final Article article;
  final String heroTag;
  const FeatureCard({Key? key, required this.article, required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(15),
        child: Stack(
          children: <Widget>[
            Hero(
              tag: heroTag,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.black12,borderRadius: BorderRadius.circular(8),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 10,
                              offset: Offset(0, 3))
                        ]),

                    child: CustomCacheImage(imageUrl: article.image, radius: 8),
                  ),

                  VideoIcon(tags: article.tags, iconSize: 80,)
                ],
              ),
            ),

            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 15, top: 15, bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            //height: 30,
                            padding: EdgeInsets.only(
                                left: 5,
                                right: 5,
                                top: 5,
                                bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context)
                                    .colorScheme
                                    .background),
                            child: Row(
                              children: [
                                Text(
                                  article.title!,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      fontWeight: FontWeight.w600),
                                ),
                                //AppService.getNormalText(article.title!),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            alignment: Alignment.center,
                            //height: 30,
                            padding: EdgeInsets.only(
                                left: 5,
                                right: 5,
                                top: 5,
                                bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context)
                                    .colorScheme
                                    .background),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.time_solid,
                                  color: Colors.grey[400],
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  article.date!,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            alignment: Alignment.center,
                            //height: 30,
                            padding: EdgeInsets.only(
                                left: 5,
                                right: 5,
                                top: 5,
                                bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground),
                            child: Row(
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
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
      onTap: ()=> navigateToDetailsScreen(context, article, heroTag)
    );
  }
}
