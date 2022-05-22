import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/settings_bloc.dart';
import 'package:wordpress_app/blocs/theme_bloc.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/config/server_config.dart';
import 'package:wordpress_app/pages/login.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/language.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with AutomaticKeepAliveClientMixin {
  void openLicenceDialog() {
    final SettingsBloc sb = Provider.of<SettingsBloc>(context, listen: false);
    showDialog(
        context: context,
        builder: (_) {
          return AboutDialog(
            applicationName: Config.appName,
            applicationLegalese: "(c) Du Cheng 2021",
            applicationVersion: sb.appVersion,
            applicationIcon: Image(
              image: AssetImage(Config.appIcon),
              height: 30,
              width: 30,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ub = context.watch<UserBloc>();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(),
        ),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                //padding: EdgeInsets.only(top: 15, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: !ub.isSignedIn ? GuestUserUI() : UserUI()),
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
                              'get notifications',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,),
                            ).tr(),
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
                                'language',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,),
                              ).tr(),
                              trailing: Icon(Feather.chevron_right),
                              onTap: () => Navigator.of(context).push(SwipeablePageRoute(
                                  canOnlySwipeFromEdge: true,
                                  builder: (BuildContext context) => LanguagePopup()),
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
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

class GuestUserUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
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
              'login',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary),
            ).tr(),
            trailing: Icon(Feather.chevron_right),
            onTap: () => Navigator.of(context).push(SwipeablePageRoute(
                canOnlySwipeFromEdge: true,
                builder: (BuildContext context) => LoginPage()),
            )
        ),
      ],
    );
  }
}

class UserUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserBloc ub = context.watch<UserBloc>();
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 18,
            child: Icon(
              Feather.user_check,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            ub.name!,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
        _Divider(),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent[100],
            radius: 18,
            child: Icon(
              Feather.mail,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            ub.email!,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
        _Divider(),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Colors.redAccent[100],
            radius: 18,
            child: Icon(
              Feather.log_out,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            'logout',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ).tr(),
          trailing: Icon(Feather.chevron_right),
          onTap: () => openLogoutDialog(context),
        ),
      ],
    );
  }

  openLogoutDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('logout description').tr(),
            title: Text('logout title').tr(),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    _handleLogout(context);
                  },
                  child: Text('logout').tr()),
            ],
          );
        });
  }

  Future _handleLogout(context) async {
    final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
    await ub
        .userSignout();
  }
}
