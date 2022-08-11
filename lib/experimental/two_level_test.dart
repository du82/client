import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../pages/home.dart';
import '../pages/search.dart';
import '../services/app_service.dart';
import '../services/barcode_scanner.dart';
import '../tabs/profile_tab.dart';
import '../tabs/video_tab.dart';
import '../utils/next_screen.dart';


class TwoLevelExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TwoLevelExampleState();
  }
}

class _TwoLevelExampleState extends State<TwoLevelExample> {
  RefreshController _refreshController1 = RefreshController();
  int _tabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    _refreshController1.headerMode?.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshController1.position?.jumpTo(0);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      dragSpeedRatio: 1,
      headerBuilder: () => const MaterialClassicHeader(),
      footerBuilder: () => const ClassicFooter(),
      enableLoadingWhenNoData: false,
      enableRefreshVibrate: true,
      enableLoadMoreVibrate: true,
      enableScrollWhenTwoLevel: true,
      maxOverScrollExtent: 120,
      maxUnderScrollExtent: 120,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Offstage(
              offstage: _tabIndex != 0,
              child: LayoutBuilder(
                builder: (_, c) {
                  return SmartRefresher(
                    header: TwoLevelHeader(
                      textStyle: TextStyle(color: Colors.white),
                      displayAlignment: TwoLevelDisplayAlignment.fromTop,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/secondfloor.jpg"),
                            fit: BoxFit.cover,
                            // 很重要的属性,这会影响你打开二楼和关闭二楼的动画效果
                            alignment: Alignment.topCenter),
                      ),
                      twoLevelWidget: TwoLevelWidget(),
                    ),
                    child: HomePage(),
                    controller: _refreshController1,
                    enableTwoLevel: true,
                    enablePullDown: true,
                    enablePullUp: true,
                    onLoading: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      _refreshController1.loadComplete();
                      showModalBottomSheet<void>(
                        backgroundColor: Theme.of(context).colorScheme.onSecondary,
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)
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
                                        left: 15, right: 15, top: 10, bottom: 10),
                                    margin: EdgeInsets.only(
                                        left: 15, right: 15, top:5),
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
                                                  onPressed: ()=> Container()
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
                                                  onPressed: ()=> Container()
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
                                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                                    }
                                                ),
                                                Text('burn').tr(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 15, right: 15, top: 10, bottom: 10),
                                    margin: EdgeInsets.only(
                                        left: 15, right: 15, top:15),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'all actions',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: -0.7,
                                              wordSpacing: 1),
                                        ).tr(),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                IconButton(
                                                    icon: Icon(
                                                      LucideIcons.flame,
                                                      size: 25,
                                                    ),
                                                    onPressed: () {
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
                                                      LucideIcons.copy,
                                                      size: 25,
                                                    ),
                                                    onPressed: () {Clipboard.setData(ClipboardData(text: 'testing'));
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('copied to clipboard'),));}
                                                ),
                                                Text('copy link').tr(),
                                              ],
                                            ),
                                            Spacer(),
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    LucideIcons.arrowRight,
                                                    size: 25,
                                                  ),
                                                  onPressed: ()=> Container()
                                                ),
                                                Text('forward').tr(),
                                              ],
                                            ),
                                            Spacer(),
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    LucideIcons.home,
                                                    size: 25,
                                                  ),
                                                  onPressed: ()=> Navigator.of(context).popUntil((route) => route.isFirst),
                                                ),
                                                Text('home').tr(),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(height: 10,),
                                        Row(
                                          children: [

                                            Column(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    LucideIcons.rotateCw,
                                                    size: 25,
                                                  ),
                                                  onPressed: ()=> Container()
                                                ),
                                                Text('reload').tr(),
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
                                                      LucideIcons.settings,
                                                      size: 25,
                                                    ),
                                                    onPressed: () {nextScreen(context, SettingPage());}
                                                ),
                                                Text('settings').tr(),
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
                                                  onPressed: ()=> Container()
                                                ),
                                                Text('share').tr(),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(height: 10,),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                IconButton(
                                                    icon: Icon(
                                                      LucideIcons.search,
                                                      size: 25,
                                                    ),
                                                    onPressed: () {nextScreen(context, SearchPage());}
                                                ),
                                                Text('search').tr(),
                                              ],
                                            ),
                                            Spacer(),
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    LucideIcons.bug,
                                                    size: 25,
                                                  ),
                                                  onPressed: ()=> Container(),
                                                ),
                                                Text('Test Bugs').tr(),
                                              ],
                                            ),
                                            Spacer(),
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    LucideIcons.externalLink,
                                                    size: 25,
                                                  ),
                                                  onPressed: ()=> AppService().openLinkWithCustomTab(
                                                      context, ('google.com')),
                                                ),
                                                Text('outlink').tr(),
                                              ],
                                            ),
                                            Spacer(),
                                            Column(
                                              children: [
                                                IconButton(
                                                    icon: Icon(
                                                      LucideIcons.play,
                                                      size: 25,
                                                    ),
                                                    onPressed: () {nextScreen(context, VideoTab());}
                                                ),
                                                Text('video').tr(),
                                              ],
                                            ),
                                          ],
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
                    onRefresh: () async {
                      await Future.delayed(Duration(milliseconds: 500));
                      _refreshController1.refreshCompleted();
                    },
                    onTwoLevel: (bool isOpen) {
                      print("twoLevel opening:" + isOpen.toString());
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class TwoLevelWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/secondfloor.jpg"),
            // 很重要的属性,这会影响你打开二楼和关闭二楼的动画效果,关联到TwoLevelHeader,如果背景一致的情况,请设置相同
            alignment: Alignment.topCenter,
            fit: BoxFit.cover),
      ),
      child: Stack(
        children: <Widget>[
          RaisedButton(
            color: Colors.greenAccent,
            onPressed: () {},
            child: Text("登陆"),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 50.0,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                ),
                child: Stack(
                  children: [
                    GestureDetector(
                      child: Icon(
                        LucideIcons.chevronsUp,
                        color: Colors.black,
                        size: 30,
                      ),
                      onTap: () {
                        SmartRefresher.of(context)?.controller.twoLevelComplete();
                      },
                    ),
                    Container(
                      height: 50.0,
                      padding: EdgeInsets.only(top: 10),
                      child: Text('Swipe up to go back', style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          letterSpacing: -0.7,
                          wordSpacing: 1,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),),
                      alignment: Alignment.topCenter,
                    ),
                  ],
                ),
                alignment: Alignment.topLeft,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
