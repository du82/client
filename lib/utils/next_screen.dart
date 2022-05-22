import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:wordpress_app/config/server_config.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/notification_model.dart';
import 'package:wordpress_app/pages/article_details.dart';
import 'package:wordpress_app/pages/custom_notification_details.dart';
import 'package:wordpress_app/pages/video_details.dart';
import 'package:wordpress_app/pages/post_notification_details.dart';

void nextScreen (context, page){
  Navigator.push(context, SwipeablePageRoute(
    canOnlySwipeFromEdge: true,
    builder: (context) => page));
}


void nextScreeniOS (context, page){
  Navigator.push(context, SwipeablePageRoute(
    canOnlySwipeFromEdge: true,
    builder: (context) => page));
}


void nextScreenCloseOthers (context, page){
  Navigator.pushAndRemoveUntil(context, SwipeablePageRoute(canOnlySwipeFromEdge: true, builder: (context) => page), (route) => false);
}

void nextScreenReplace (context, page){
  Navigator.pushReplacement(context, SwipeablePageRoute(canOnlySwipeFromEdge: true, builder: (context) => page));
}


void nextScreenPopup (context, page){
  Navigator.push(context, SwipeablePageRoute(
    fullscreenDialog: true,
    canOnlySwipeFromEdge: true,
    builder: (context) => page),
  );
}


void navigateToDetailsScreen (context, Article article, String? heroTag){
  if(article.tags == null || !article.tags!.contains(WpConfig.videoTagId)){
    Navigator.push(context, SwipeablePageRoute(
      canOnlySwipeFromEdge: true,
      builder: (context) => ArticleDetails(articleData: article, tag: heroTag,)),
    );
  }else{
     Navigator.push(context, SwipeablePageRoute(
      canOnlySwipeFromEdge: true,
      builder: (context) => VideoDetails(article: article)),

    );
  }
}

void navigateToDetailsScreenByReplace (context, Article article, String? heroTag){
  if(article.tags == null || !article.tags!.contains(WpConfig.videoTagId)){
    Navigator.pushReplacement(context, SwipeablePageRoute(
      canOnlySwipeFromEdge: true,
      builder: (context) => ArticleDetails(articleData: article, tag: heroTag,)),
    );
  }else{
     Navigator.pushReplacement(context, SwipeablePageRoute(
      canOnlySwipeFromEdge: true,
      builder: (context) => VideoDetails(article: article)),
    );
  }
}


void navigateToNotificationDetailsScreen (context, NotificationModel notificationModel){
  if(notificationModel.postID == null){
    nextScreen(context, CustomNotificationDeatils(notificationModel: notificationModel));
  }else{
    nextScreen(context, PostNotificationDetails(postID: notificationModel.postID!));
  }
}