import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/utils/vertical_line.dart';

class PromotionMiniProgram extends StatefulWidget {
  final String? title;
  final String? url;
  const PromotionMiniProgram({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  _RenderMiniProgramState createState() => _RenderMiniProgramState();
}

class _RenderMiniProgramState extends State<PromotionMiniProgram> with AutomaticKeepAliveClientMixin {
  late WebViewController theWebViewController;
  TextEditingController theController = new TextEditingController();
  bool showLoading = false;

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
                                        LucideIcons.moreHorizontal,
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
                                        LucideIcons.x,
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
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              height: 45,
                              //width: 100,
                              decoration: BoxDecoration(
                                  color: Color(0xff4360DF).withOpacity(1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.background.withOpacity(1),
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.download,
                                    color: Theme.of(context).colorScheme.background,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Download Status',
                                    maxLines: 1,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        letterSpacing: -0.7,
                                        wordSpacing: 1,
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.background,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),

                            //onTap: ()=> nextScreen(context, SearchPage()),
                            onTap: () => nextScreen(
                                context, Container(),
                            )
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