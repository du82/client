import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/utils/vertical_line.dart';

import '../utils/snacbar.dart';

class RenderRaw extends StatefulWidget {
  final String? title;
  final String? url;
  const RenderRaw({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  _RenderMiniProgramState createState() => _RenderMiniProgramState();
}

class _RenderMiniProgramState extends State<RenderRaw> with AutomaticKeepAliveClientMixin {
  late WebViewController theWebViewController;
  TextEditingController theController = new TextEditingController();
  bool showLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void updateLoading(bool ls) {
    this.setState(() {
      showLoading = ls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          
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
                      initialUrl: widget.url! + "?mp=" + widget.title!,
                      onPageFinished: (data) {
                        updateLoading(false);
                      },
                      javascriptMode: JavascriptMode.unrestricted,
                      zoomEnabled: false,
                      onWebViewCreated: (webViewController) {
                        theWebViewController = webViewController;
                      },
                      gestureNavigationEnabled: true,
                    ),
                    (showLoading)
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : Center(),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.only(left: 0, right: 5),
                              margin: EdgeInsets.all(5),
                              height: 30,
                              width: 75,
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background.withOpacity(1),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    width: 0.5
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    child: IconButton(
                                      padding: EdgeInsets.only(right: 0, left: 3),
                                      constraints: BoxConstraints(),
                                      icon: SvgPicture.asset(
                                        'assets/icons/dots.svg',
                                        width: 30,
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
                                              height: 150,
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              child: Center(

                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  verticalLine(context, 50.0),
                                  SizedBox(width: 5),
                                  /*Container(
                                    child: IconButton(
                                      padding: EdgeInsets.only(right: 3, left: 0),
                                      constraints: BoxConstraints(),
                                      icon: SvgPicture.asset(
                                        'assets/icons/x-circle.svg',
                                        width: 20,
                                      ),
                                      onPressed: () => Navigator.of(context).pop(null),
                                    ),
                                  ),*/
                                  Container(
                                    padding: EdgeInsets.only(right: 5, left: 5),
                                    child: InkWell(
                                        child: SvgPicture.asset(
                                          'assets/icons/x-circle.svg',
                                          width: 20,
                                        ),
                                        onLongPress: () {
                                          Navigator.of(context).pop(null);
                                          HapticFeedback.heavyImpact();
                                        },
                                        onTap: () {
                                          final snackBar = SnackBar(
                                            content: const Text('long press mini program').tr(),
                                            action: SnackBarAction(
                                              label: 'got it'.tr(),
                                              onPressed: () {
                                                // Some code to undo the change.
                                              },
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        },
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