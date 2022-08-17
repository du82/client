import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/utils/vertical_line.dart';

class RenderMiniProgram extends StatefulWidget {
  final String? title;
  final String? url;
  const RenderMiniProgram({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  _RenderMiniProgramState createState() => _RenderMiniProgramState();
}

class _RenderMiniProgramState extends State<RenderMiniProgram> with AutomaticKeepAliveClientMixin {
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
                              margin: EdgeInsets.all(10),
                              height: 25,
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
                                      icon: SvgPicture.asset('assets/icons/applet-closed.svg'),
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