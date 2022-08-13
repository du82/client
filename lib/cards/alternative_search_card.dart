import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/cached_image.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/video_icon.dart';


//card for alternative search providers
class AlternativeSearch extends StatelessWidget {
  const AlternativeSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final bookmarkedList = Hive.box(Constants.bookmarkTag);
    return InkWell(
        child: Container(
            padding: EdgeInsets.only(
                left: 10, right: 10, top: 0, bottom: 0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container()),
        //onTap: () => navigateToDetailsScreenByReplace(context, article, null)
    );
  }
}
