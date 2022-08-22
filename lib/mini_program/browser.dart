import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share/share.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:wordpress_app/pages/search.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/cards/search_cards/search_hint_qrcode.dart';

import '../services/barcode_scanner.dart';

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
      appBar: AppBar(
        elevation: 0.2,
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 175,
                      decoration: BoxDecoration(
                          //color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 8),
                            child: Icon(
                              LucideIcons.search,
                              size: 20,
                            ),
                          ),
                          if (widget!.url!.startsWith('https://'))
                            Flexible(
                              child: Text(
                                '${widget.url?.replaceRange(0, 8, "")}',
                                maxLines: 1,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    letterSpacing: -0.7,
                                    wordSpacing: 1,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          else
                            Flexible(
                              child: Text(
                                '${widget.url?.replaceRange(0, 8, "")}',
                                maxLines: 1,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    letterSpacing: -0.7,
                                    wordSpacing: 1,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                        ],
                      ),
                    ),
                  ]
              ),
              onTap: () => nextScreen(context, SearchPage()),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                  ),
                  child: SvgPicture.asset('assets/icons/refresh.svg'),
                ),
                onPressed: () {Navigator.pop(context);},
              ),
              InkWell(
                child: IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.only(
                        right: 15
                    ),
                    child: Icon(
                      LucideIcons.moreVertical,
                      size: 20,
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      isScrollControlled: false,
                      backgroundColor: Theme.of(context).colorScheme.onSecondary,
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)
                        ),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                          color: Theme.of(context).colorScheme.onSecondary,
                          margin: EdgeInsets.only(top: 12),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 10),
                                    child: SearchHintQRcode()),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                onLongPress: () => Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 40,
        child: BottomAppBar(
          color: Theme.of(context).backgroundColor,
          child: Row(
            children: [
              InkWell(
                child: IconButton(
                  icon: Icon(
                    LucideIcons.chevronLeft,
                    //size: 26,
                  ), onPressed: () {Navigator.pop(context);},
                ),
                onLongPress: () => Navigator.of(context).popUntil((route) => route.isFirst),
              ),
              //SizedBox(width: 8),
              Spacer(),
              IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(
                      left: 5,
                      right: 8
                  ),
                  child: Icon(
                    LucideIcons.rotateCw,
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
                    LucideIcons.alignRight,
                    size: 30,
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet<void>(
                    isScrollControlled: false,
                    backgroundColor: Theme.of(context).colorScheme.onSecondary,
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)
                      ),
                    ),
                    builder: (BuildContext context) {
                      return Container(
                        color: Theme.of(context).colorScheme.onSecondary,
                        margin: EdgeInsets.only(top: 12),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 3),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'suggested actions',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.7,
                                          wordSpacing: 1),
                                    ).tr(),
                                    Container(height: 10,),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                LucideIcons.arrowRight,
                                                size: 25,
                                              ),
                                              onPressed: ()=> theWebViewController.goForward(),
                                            ),
                                            Text('forward').tr(),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          children: [
                                            IconButton(
                                                icon: Icon(
                                                  LucideIcons.share,
                                                  size: 25,
                                                ),
                                              onPressed: ()=> _handleShare(),
                                            ),
                                            Text('share').tr(),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          children: [
                                            IconButton(
                                                icon: Icon(
                                                  LucideIcons.scanLine,
                                                  size: 25,
                                                ),
                                                onPressed: () => Navigator.of(context).push(SwipeablePageRoute(
                                                    canOnlySwipeFromEdge: true,
                                                    builder: (BuildContext context) => BarcodeScannerWithController()),
                                                )
                                            ),
                                            Text('scan').tr(),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                LucideIcons.flame,
                                                size: 25,
                                              ),
                                              onPressed: () {
                                                theWebViewController.clearCache();
                                                Navigator.of(context).popUntil((route) => route.isFirst);
                                              }
                                            ),
                                            Text('burn').tr(),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                LucideIcons.rotateCw,
                                                size: 25,
                                              ),
                                              onPressed: ()=> theWebViewController.reload(),
                                            ),
                                            Text('reload').tr(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                  child: SearchHintQRcode()),
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
                        if (request.url.contains('status.im') ||
                            request.url.contains('facebook.com') ||
                            request.url.contains('https://observatory.mozilla.org') ||
                            request.url.contains('.pdf')
                        ){
                          return NavigationDecision.prevent;
                        } else {
                          if (request.url.endsWith("?mp=render")) {
                            AppService().openLinkWithRenderMiniProgram(
                                context, (request.url));
                            return NavigationDecision.prevent;
                          } else if (request.url.endsWith("?mp=chromium")) {
                            AppService().openLinkWithCustomTab(
                                context, (request.url));
                            return NavigationDecision.prevent;
                          } else {
                            AppService().openLinkWithBrowserMiniProgram(
                                context, (request.url));
                            return NavigationDecision.prevent;
                          }
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