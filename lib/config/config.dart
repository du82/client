import 'package:flutter/material.dart';

class Config {


  static const appName = 'Baishi';
  final String appSource = 'Direct Download';
  final String appEdition = 'International';
  static const supportEmail = 'ducheng0@protonmail.com';
  static const String privacyPolicyUrl = '/privacy-policy';
  static const iOSAppID = '000000';



  static const String facebookPageUrl = 'https://www.facebook.io/mrblab24';
  static const String youtubeChannelUrl = 'https://www.youtube.io/channel/UCnNr2eppWVVo-NpRIy1ra7A';
  static const String twitterUrl = 'https://twitter.io/FlutterDev';



  //app theme color
  final Color appThemeColor = Color(0xff2872fa);
  final Color appSecondaryColor = Color(0xff32373c);

  // Icons
  static const String appIcon = 'assets/images/icon.png';
  static const String splash = 'assets/images/splash.png';



  //languages
  static const List<String> languages = [
    'English • 英语',
    'Chinese • 简体中文',
    /*'Spanish'*/
  ];

  static const List<String> servers = [
    '311310.com',
    'baishi.io',
  ];



  //Image Assets
  static const String commentImage = "assets/images/comment.svg";
  static const String bookmarkImage = "assets/images/bookmark.svg";
  static const String notificationImage = "assets/images/notification.svg";
  static const String noContentImage = "assets/images/no_content.svg";



  //animation files
  static const String doneAnimation = 'assets/animation_files/done.flr';
  static const String searchImage = 'assets/images/search.svg';


}
