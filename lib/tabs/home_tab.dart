import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:wordpress_app/blocs/featured_bloc.dart';
import 'package:wordpress_app/blocs/latest_articles_bloc.dart';
import 'package:wordpress_app/blocs/popular_articles_bloc.dart';
import 'package:wordpress_app/blocs/tab_index_bloc.dart';
import 'package:wordpress_app/config/server_config.dart';
import 'package:wordpress_app/pages/search.dart';
import 'package:wordpress_app/services/barcode_scanner.dart';
import 'package:wordpress_app/widgets/tab_medium.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {


  late TabController _tabController ;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Tab> _tabs = [
    Tab(
      text: "explore".tr(),
    ),
    Tab(
      text: WpConfig.selectedCategories['1'][1],
    ),
    Tab(
      text: WpConfig.selectedCategories['2'][1],
    ),
    Tab(
      text: WpConfig.selectedCategories['3'][1],
    ),
    Tab(
      text: WpConfig.selectedCategories['4'][1],
    ),
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, initialIndex: 0, vsync: this);
    _tabController.addListener(() {
      context.read<TabIndexBloc>().setTabIndex(_tabController.index);
    });
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      context.read<FeaturedBloc>().fetchData();
      context.read<PopularArticlesBloc>().fetchData();
      context.read<LatestArticlesBloc>().fetchData();
    });
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                automaticallyImplyLeading: false,
                centerTitle: false,
                titleSpacing: 0,
                snap: true,
                floating: true,
                pinned: true,
                backgroundColor: Theme.of(context).primaryColor,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                flexibleSpace: Image(
                  //image: CachedNetworkImageProvider('${WpConfig.websiteUrl}/app-content/backgrounds/main.jpg'),
                  image: CachedNetworkImageProvider('https://source.unsplash.com/random/?nature'),
                  fit: BoxFit.fitWidth,
                ),
                title: Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: InkWell(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background.withOpacity(1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0),
                                width: 1.3
                            )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              LucideIcons.search,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 23,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'search contents',
                              maxLines: 1,
                              style: TextStyle(
                                  overflow: TextOverflow.clip,
                                  letterSpacing: -0.7,
                                  wordSpacing: 1,
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w500),
                            ).tr(),
                            //Container(width: MediaQuery.of(context).size.width - 305,),
                            Spacer(),
                            InkWell(
                              child: SvgPicture.asset(
                                  'assets/icons/scan-code.svg',
                                  color: Theme.of(context).colorScheme.secondary,
                                  width: 23,
                                ),
                              onTap: () {
                                Navigator.of(context).push(SwipeablePageRoute(canOnlySwipeFromEdge: true, builder: (BuildContext context) => BarcodeScannerWithController()));
                                HapticFeedback.heavyImpact();
                              }
                            ),
                            Container(width: 15,),
                            /*InkWell(
                              child: Icon(
                                LucideIcons.plusCircle,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 23,
                              ),
                              onTap: () {
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
                                      height: MediaQuery.of(context).size.height - 70,
                                      //color: Colors.amber,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const Text('Modal BottomSheet'),
                                            ElevatedButton(
                                              child: const Text('Close BottomSheet'),
                                              onPressed: () => Navigator.pop(context),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),*/
                            PopupMenuButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                enableFeedback: true,
                                elevation: 0,
                                color: Colors.grey[800],
                                child: Icon(
                                  LucideIcons.plusCircle,
                                  color: Theme.of(context).colorScheme.secondary,
                                  size: 23,
                                ),
                                itemBuilder: (BuildContext context) {
                                  return <PopupMenuItem>[
                                    PopupMenuItem(
                                      value: 'scan',
                                      child: Row(
                                        children: <Widget>[
                                          Icon(LucideIcons.scanLine, color: Colors.white,),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text("scan code",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),).tr(),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'dislike',
                                      child: Row(
                                        children: <Widget>[
                                          Icon(LucideIcons.pencil, color: Colors.white,),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text("Create",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'share',
                                      child: Row(
                                        children: <Widget>[
                                          Icon(LucideIcons.share, color: Colors.white,),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text("Share",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'report',
                                      child: Row(
                                        children: <Widget>[
                                          Icon(LucideIcons.settings, color: Colors.white,),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text("Settings",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                onSelected: (dynamic value) {
                                  if (value == 'scan') {
                                    Navigator.of(context).push(SwipeablePageRoute(
                                        canOnlySwipeFromEdge: true,
                                        builder: (BuildContext context) => BarcodeScannerWithController()));
                                  } else if (value == 'dislike') {
                                    Navigator.of(context).push(SwipeablePageRoute(
                                        canOnlySwipeFromEdge: true,
                                        builder: (BuildContext context) => BarcodeScannerWithController()));
                                  } else {
                                    Container();
                                  }
                                }
                              ),
                          ],
                        ),
                      ),
                      onTap: () => Navigator.of(context).push(SwipeablePageRoute(
                          canOnlySwipeFromEdge: true,
                          builder: (BuildContext context) => SearchPage()),
                      )
                  ),
                ),
                forceElevated: innerBoxIsScrolled,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(36),
                  child: ColoredBox(
                    color: Theme.of(context).backgroundColor,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 35,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: TabBar(
                              indicatorPadding: EdgeInsets.symmetric(horizontal: 8),
                              controller: _tabController,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelColor: Theme.of(context).primaryColor,
                              labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                              labelPadding: EdgeInsets.symmetric(horizontal: 10),
                              unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                              isScrollable: true,
                              indicator: MD2Indicator(
                                indicatorHeight: 3,
                                indicatorColor: Theme.of(context).primaryColor,
                                indicatorSize: MD2IndicatorSize.full,
                              ),
                              tabs: _tabs,
                            ),
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).dividerColor,
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },

          body: Builder(
            builder: (BuildContext context) {
              final innerScrollController = PrimaryScrollController.of(context);
              return TabMedium(
                sc: innerScrollController!,
                tc: _tabController,
                scaffoldKey: scaffoldKey,
              );
            },
          )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
