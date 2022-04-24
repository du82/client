import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:wordpress_app/config/server_config.dart';
import 'package:wordpress_app/pages/login.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/utils/vertical_line.dart';
import '../render.dart';
import 'http_service.dart';
import 'post_detail.dart';
import 'post_model.dart';

class PostsMiniProgram extends StatelessWidget {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        leading: Container(),
        titleSpacing: 0,
        actions: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    margin: EdgeInsets.all(5),
                    height: 33,
                    width: 75,
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background.withOpacity(1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: IconButton(
                            padding: EdgeInsets.only(right: 0, left: 0),
                            constraints: BoxConstraints(),
                            icon: Icon(
                              Feather.more_horizontal,
                              //size: 25,
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
                                    height: 200,
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10, top: 10, bottom: 00),
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.onPrimary,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'mini programs',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700,
                                                      letterSpacing: -0.7,
                                                      wordSpacing: 1),
                                                ),
                                                SizedBox(height: 15),
                                                ListTile(
                                                  contentPadding: EdgeInsets.all(0),
                                                  leading: CircleAvatar(
                                                    backgroundColor: Colors.black,
                                                    radius: 18,
                                                    child: Icon(
                                                      Feather.terminal,
                                                      size: 18,
                                                      color: Colors.greenAccent,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    'Terminal',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Theme.of(context).colorScheme.primary),
                                                  ),
                                                  trailing: Icon(Feather.chevron_right),
                                                ),
                                                SizedBox(height: 15),
                                                ListTile(
                                                  contentPadding: EdgeInsets.all(0),
                                                  leading: CircleAvatar(
                                                    backgroundColor: Colors.black,
                                                    radius: 18,
                                                    child: Icon(
                                                      Feather.terminal,
                                                      size: 18,
                                                      color: Colors.greenAccent,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    'RenderMiniProgram',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Theme.of(context).colorScheme.primary),
                                                  ),
                                                  trailing: Icon(Feather.chevron_right),
                                                  onTap: () => nextScreen(context, RenderMiniProgram(url: 'baishi.io', title: "Render")),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 7),
                        verticalLine(context, 50.0),
                        SizedBox(width: 6.5),
                        Container(
                          child: IconButton(
                            padding: EdgeInsets.only(right: 0, left: 0),
                            constraints: BoxConstraints(),
                            icon: Icon(
                              Feather.x,
                              //size: 25,
                            ),
                            onPressed: () => Navigator.of(context).pop(null),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: httpService.getPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasData) {
            List<Post>? posts = snapshot.data;

            return ListView(
              children: posts!.map(
                    (Post post) => ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover, image: CachedNetworkImageProvider(WpConfig.websiteUrl + "/app-content/assets/noAccountImage.png")),
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        title: Text(
                          post.title,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary),
                        ).tr(),
                        trailing: Icon(Feather.chevron_right),
                        onTap: () => Navigator.of(context).push(SwipeablePageRoute(
                            builder: (BuildContext context) => PostDetail(post: post,)),
                        )
                    ),
              )
                  .toList(),
            );

          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
