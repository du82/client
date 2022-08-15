import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wordpress_app/cards/bookmark_card.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/constants.dart';
import 'package:wordpress_app/services/bookmark_service.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:easy_localization/easy_localization.dart';

class BookmarkTab extends StatefulWidget {
  const BookmarkTab({Key? key}) : super(key: key);

  @override
  _BookmarkTabState createState() => _BookmarkTabState();
}

class _BookmarkTabState extends State<BookmarkTab> with AutomaticKeepAliveClientMixin {


  void _openCLearAllDialog (){
    showModalBottomSheet(
      elevation: 2,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18)
      )),
      context: context, builder: (context){
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        height: 250,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('clear all bookmark-dialog', 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.6,
              wordSpacing: 1
            ),).tr(),
            SizedBox(height: 20,),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 18,
                        child: Icon(
                          Feather.globe,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        'clear',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,),
                      ).tr(),
                      trailing: Icon(Feather.chevron_right),
                      onTap: (){
                        BookmarkService().clearBookmarkList();
                        Navigator.pop(context);
                      },
                  ),
                  _Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      radius: 18,
                      child: Icon(
                        Feather.globe,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,),
                    ).tr(),
                    trailing: Icon(Feather.chevron_right),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ),
          ],
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bookmarkList = Hive.box(Constants.bookmarkTag);
    return Scaffold(
      appBar: AppBar(
        title: Text('bookmarks').tr(),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: ()=> _openCLearAllDialog(),
            child: Text('clear all').tr(),
            style: ButtonStyle(
                padding: MaterialStateProperty.resolveWith(
                    (states) => EdgeInsets.only(right: 15, left: 15))),
          ),

        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: bookmarkList.listenable(),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  if(bookmarkList.isEmpty) return EmptyPageWithImage(
                    image: Config.commentImage,
                    title: 'nothing bookmarked'.tr(),
                    description: 'bookmark description'.tr(),
                  );

                  return ListView.separated(
                    padding: EdgeInsets.all(15),
                    itemCount: bookmarkList.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: 15,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      Article article = Article(
                          id: bookmarkList.getAt(index)['id'],
                          title: bookmarkList.getAt(index)['title'],
                          content: bookmarkList.getAt(index)['content'],
                          image: bookmarkList.getAt(index)['image'],
                          video: bookmarkList.getAt(index)['video'],
                          author: bookmarkList.getAt(index)['author'],
                          avatar: bookmarkList.getAt(index)['avatar'],
                          category: bookmarkList.getAt(index)['category'],
                          date: bookmarkList.getAt(index)['date'],
                          timeAgo: bookmarkList.getAt(index)['time_ago'],
                          link: bookmarkList.getAt(index)['link'],
                          catId: bookmarkList.getAt(index)['catId'],
                          tags: bookmarkList.getAt(index)['tags']
                      );

                      return BookmarkCard(article: article);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _Divider extends StatelessWidget {
  const _Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.0,
      thickness: 0.2,
      indent: 50,
      color: Colors.grey[400],
    );
  }
}

