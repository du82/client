import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share/share.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/pages/search.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/next_screen.dart';

class BrowserMiniProgram extends StatefulWidget {
  final String? title;
  final String? url;
  const BrowserMiniProgram({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  _BrowserMiniProgramState createState() => _BrowserMiniProgramState();
}

class _BrowserMiniProgramState extends State<BrowserMiniProgram> with AutomaticKeepAliveClientMixin {
  late WebViewController theWebViewController;
  TextEditingController theController = new TextEditingController();
  bool showLoading = false;

  Future _handleShare() async {
    Share.share(widget.url!);
  }

  void updateLoading(bool ls) {
    this.setState(() {
      showLoading = ls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).backgroundColor,
        child: Row(
          children: [
            IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(
                    left: 5,
                    right: 0
                ),
                child: Icon(
                  LucideIcons.chevronLeft,
                  size: 32,
                ),
              ),
              onPressed: ()=> Navigator.pop(context),
            ),
            IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(
                    left: 0,
                    right: 0
                ),
                child: Icon(
                  LucideIcons.x,
                  size: 30,
                ),
              ),
              onPressed: ()=> Navigator.of(context).popUntil((route) => route.isFirst),
            ),
            SizedBox(width: 8),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 20),
                height: 35,
                width: MediaQuery.of(context).size.width - 220,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      LucideIcons.search,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'search browser',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ],
                ),
              ),
              onTap: () => nextScreen(context, SearchPage()),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(
                    left: 5,
                    right: 8
                ),
                child: Icon(
                  LucideIcons.cornerUpRight,
                  size: 25,
                ),
              ),
              onPressed: ()=> _handleShare(),
            ),
            IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(
                    left: 5,
                    right: 5
                ),
                child: Icon(
                  LucideIcons.gripHorizontal,
                  size: 28,
                ),
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                  backgroundColor: Theme.of(context).backgroundColor,
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                IconButton(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 8
                                    ),
                                    child: Icon(
                                      LucideIcons.cornerUpRight,
                                      size: 25,
                                    ),
                                  ),
                                  onPressed: ()=> _handleShare(),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 8
                                    ),
                                    child: Icon(
                                      LucideIcons.cornerUpRight,
                                      size: 25,
                                    ),
                                  ),
                                  onPressed: ()=> _handleShare(),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 8
                                    ),
                                    child: Icon(
                                      LucideIcons.cornerUpRight,
                                      size: 25,
                                    ),
                                  ),
                                  onPressed: ()=> _handleShare(),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 8
                                    ),
                                    child: Icon(
                                      LucideIcons.cornerUpRight,
                                      size: 25,
                                    ),
                                  ),
                                  onPressed: ()=> _handleShare(),
                                ),
                                Spacer(),
                              ],
                            ),
                            Container(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                IconButton(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 8
                                    ),
                                    child: Icon(
                                      LucideIcons.cornerUpRight,
                                      size: 25,
                                    ),
                                  ),
                                  onPressed: ()=> _handleShare(),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 8
                                    ),
                                    child: Icon(
                                      LucideIcons.cornerUpRight,
                                      size: 25,
                                    ),
                                  ),
                                  onPressed: ()=> _handleShare(),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 8
                                    ),
                                    child: Icon(
                                      LucideIcons.cornerUpRight,
                                      size: 25,
                                    ),
                                  ),
                                  onPressed: ()=> _handleShare(),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 8
                                    ),
                                    child: Icon(
                                      LucideIcons.cornerUpRight,
                                      size: 25,
                                    ),
                                  ),
                                  onPressed: ()=> _handleShare(),
                                ),
                                Spacer(),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                flex: 12,
                child: Stack(
                  children: <Widget>[
                    WebView(
                      initialUrl: widget.url!,
                      onPageFinished: (data) {
                        updateLoading(false);
                      },
                      javascriptMode: JavascriptMode.unrestricted,
                      navigationDelegate: (request) {
                        if (request.url.contains('https://ads.twitter.com') ||
                            request.url.contains('https://facebook.com') ||
                            request.url.contains('https://observatory.mozilla.org') ||
                            request.url.contains('.pdf')
                        ){
                          return NavigationDecision.prevent;
                        } else {
                          AppService().openLinkWithBrowserMiniProgram(
                              context, (request.url));
                          return NavigationDecision.prevent;
                        }
                      },
                      onWebViewCreated: (webViewController) {
                        theWebViewController = webViewController;
                      },
                    ),
                    (showLoading)
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : Center(),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}