import 'dart:io';
import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:hive/hive.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:url_launcher/url_launcher.dart';
import 'package:wordpress_app/blocs/settings_bloc.dart';
import 'package:wordpress_app/blocs/theme_bloc.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/mini_program/browser.dart';
import 'package:wordpress_app/mini_program/render.dart';
import 'package:wordpress_app/models/constants.dart';
import 'package:intl/intl.dart' as intl;
import 'package:wordpress_app/utils/toast.dart';

class AppService {


  Future<bool?> checkInternet() async {
    bool? internet;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        internet = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      internet = false;
    }
    return internet;
  }

  Future addToRecentSearchList(String newSerchItem) async {
    final hive = await Hive.openBox(Constants.resentSearchTag);
    hive.add(newSerchItem);
  }



  Future removeFromRecentSearchList(int selectedIndex) async {
    final hive = await Hive.openBox(Constants.resentSearchTag);
    hive.deleteAt(selectedIndex);
  }

  Future openLink(context, String url) async {
    if (await urlLauncher.canLaunch(url)) {
      urlLauncher.launch(url);
    } else {
      openToast1(context, "Can't launch the url");
    }
  }

  

  Future openEmailSupport(context) async {
    //await urlLauncher.launch('mailto:${Config.supportEmail}?subject=About ${Config.appName} App&body=');

    final Uri params = Uri(
      scheme: 'mailto',
      path: Config.supportEmail,
      query: 'subject=About ${Config.appName}&body=', //add subject and body here
    );

    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      openToast1(context, "Can't open the email app");
    }
  }

  Future openLinkWithBrowserMiniProgram(BuildContext context, String url) async {
    try{
      Navigator.of(context).push(SwipeablePageRoute(
          builder: (BuildContext context) => BrowserMiniProgram(url: url, title: "Browser",)));
    }catch(e){
      openToast1(context, 'Cant launch the url');
      debugPrint(e.toString());
    }
  }

  Future openLinkWithRenderMiniProgram(BuildContext context, String url) async {
    try{
      Navigator.of(context).push(SwipeablePageRoute(
          builder: (BuildContext context) => RenderMiniProgram(url: url, title: "Render",)));
    }catch(e){
      openToast1(context, 'Cant launch the url');
      debugPrint(e.toString());
    }
  }

  Future openLinkWithCustomTab(BuildContext context, String url) async {
    try{
      await FlutterWebBrowser.openWebPage(
      url: url,
      customTabsOptions: CustomTabsOptions(
        colorScheme: context.read<ThemeBloc>().darkTheme! ? CustomTabsColorScheme.dark : CustomTabsColorScheme.light,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        barCollapsingEnabled: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
    }catch(e){
      openToast1(context, 'Cant launch the url');
      debugPrint(e.toString());
    }
  }



  Future launchAppReview(context) async {
    final SettingsBloc sb = Provider.of<SettingsBloc>(context, listen: false);
    LaunchReview.launch(
        androidAppId: sb.packageName,
        iOSAppId: Config.iOSAppID,
        writeReview: false);
    if (Platform.isIOS) {
      if (Config.iOSAppID == '000000') {
        openToast1(context, 'The iOS version is not available on the AppStore yet');
      }
    }
  }




  static bool isDirectionRTL(BuildContext context) {
    return intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);
  }


  static getNormalText (String text){
    return HtmlUnescape().convert(parse(text).documentElement!.text);
  }

}
