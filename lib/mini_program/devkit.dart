import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/src/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:wordpress_app/blocs/theme_bloc.dart';
import 'package:wordpress_app/config/server_config.dart';
import 'package:wordpress_app/mini_program/promotion_render.dart';
import 'package:wordpress_app/mini_program/render.dart';
import 'package:wordpress_app/mini_program/selector/posts.dart';
import 'package:wordpress_app/mini_program/test_browser.dart';
import 'package:wordpress_app/tabs/profile_tab.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/utils/vertical_line.dart';
import 'package:wordpress_app/widgets/language.dart';
import 'package:wordpress_app/widgets/server.dart';

import '../config/config.dart';

class DevKitMiniProgram extends StatefulWidget {
  const DevKitMiniProgram({Key? key}) : super(key: key);

  @override
  _DevKitMiniProgramState createState() => _DevKitMiniProgramState();
}

class _DevKitMiniProgramState extends State<DevKitMiniProgram> {
  @override
  Widget build(BuildContext context) {
    var ub;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        title: Text("Development Kit"),
        centerTitle: true,
        titleSpacing: 0,
        actions: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(5),
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                ),
                child: Icon(
                  Feather.chevron_left,
                  size: 32,
                ),
              ),
              onPressed: ()=> Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 0, bottom: 0),
              margin: EdgeInsets.only(
                  left: 10, right: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
          ),
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
                  'general settings',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.7,
                      wordSpacing: 1),
                ).tr(),
                SizedBox(height: 15),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    radius: 18,
                    child: Icon(
                      Feather.bell,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Send Test Ntoficiation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  /*trailing: Switch(
                            activeColor: Theme.of(context).primaryColor,
                            value: context.watch<NotificationBloc>().subscribed!,
                            onChanged: (bool value) => context
                                .read<NotificationBloc>()
                                .configureFcmSubscription(value)),*/
                ),
                _Divider(),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    radius: 18,
                    child: Icon(
                      Feather.sun,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'dark mode',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  trailing: Switch(
                      activeColor: Theme.of(context).primaryColor,
                      value: context.watch<ThemeBloc>().darkTheme!,
                      onChanged: (bool) {
                        context.read<ThemeBloc>().toggleTheme();
                      }),
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
                      'Enforce Chinese Language Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,),
                    ).tr(),
                    trailing: Icon(Feather.chevron_right),
                    onTap: () => Navigator.of(context).push(SwipeablePageRoute(
                        builder: (BuildContext context) => LanguagePopup()),
                    )
                ),
                _Divider(),
                ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      radius: 18,
                      child: Icon(
                        Feather.server,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'Select Development Server',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,),
                    ).tr(),
                    trailing: Icon(Feather.chevron_right),
                    onTap: () => Navigator.of(context).push(SwipeablePageRoute(
                        builder: (BuildContext context) => ServerPopup()),
                    )
                ),
              ],
            ),
          ),
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
                ).tr(),
                SizedBox(height: 15),
                /*ListTile(
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
                            ).tr(),
                            trailing: Icon(Feather.chevron_right),
                            onTap: () => nextScreenPopup(context, Notifications()),
                          ),
                          SizedBox(height: 15),*/
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
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  trailing: Icon(Feather.chevron_right),
                  onTap: () => nextScreen(context, RenderMiniProgram(url: 'baishi.io', title: "Render")),
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
                    'Experimental Web Browser',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  trailing: Icon(Feather.chevron_right),
                  onTap: () => nextScreen(context, WebViewExample()),
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
                    'Promotion Test',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  trailing: Icon(Feather.chevron_right),
                  onTap: () => nextScreen(context, PromotionMiniProgram(url: 'status.im', title: "Status")),
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
                    'Promotion Test',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  ).tr(),
                  trailing: Icon(Feather.chevron_right),
                  onTap: () => nextScreen(context, PostsMiniProgram()),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            padding: EdgeInsets.only(
                left: 10, right: 10, top: 10, bottom: 00),
            margin: EdgeInsets.only(
                left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: CachedNetworkImageProvider(WpConfig.websiteUrl + "/app-content/assets/noAccountImage.png")),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          Container(
            height: 100,
            padding: EdgeInsets.only(
                left: 10, right: 10, top: 10, bottom: 00),
            margin: EdgeInsets.only(
                left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: CachedNetworkImageProvider(WpConfig.websiteUrl + "/app-content/assets/noAccountImage.png")),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          Container(
            height: 100,
            padding: EdgeInsets.only(
                left: 10, right: 10, top: 10, bottom: 00),
            margin: EdgeInsets.only(
                left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: CachedNetworkImageProvider(WpConfig.websiteUrl + "/app-content/assets/noAccountImage.png")),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemList(d, index) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: 10, right: 10, top: 0, bottom: 0),
          margin: EdgeInsets.only(
              left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Icon(Feather.server, size: 22,),
            horizontalTitleGap: 10,
            title: Text(d, style: TextStyle(
                fontWeight: FontWeight.w500
            ),),
            onTap: () async {
              if(d == '311310.com'){
                await context.setLocale(Locale('en'));
              }
              else if(d == 'baishi.io'){
                await context.setLocale(Locale('zh'));
              }
              else if(d == 'Spanish'){
                await context.setLocale(Locale('es'));
              }
              Navigator.pop(context);
            },
          ),
        ),

      ],
    );
  }
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