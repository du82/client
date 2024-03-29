import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wordpress_app/blocs/category_bloc.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/tabs/profile_tab.dart';
import 'package:wordpress_app/tabs/video_tab.dart';
import 'package:wordpress_app/utils/snacbar.dart';
import '../tabs/bookmark_tab.dart';
import '../tabs/home_tab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int selectedIndex = 0;
  PageController? _pageController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<IconData> iconList = [
    LucideIcons.home,
    //LucideIcons.play,
    //Feather.search,
    LucideIcons.bookmark,
    LucideIcons.user
  ];



  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    AppService().checkInternet().then((hasInternet) {
      if (hasInternet!) {
        context.read<CategoryBloc>().fetchData();
      }else{
        openSnacbar(scaffoldKey, 'no internet'.tr());
      }
    });
  }

  

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      
    });
    _pageController!.animateToPage(index, duration: Duration(milliseconds: 10), curve: Curves.linear);
  }


  Future _onWillPop () async{
    if(selectedIndex != 0){
      setState (()=> selectedIndex = 0);
      _pageController!.animateToPage(0, duration: Duration(milliseconds: 10), curve: Curves.linear);
    }else{
      await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true);
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async => await _onWillPop(),
          child: Scaffold(
              key: scaffoldKey,
              bottomNavigationBar: _bottonNavigationBar(context),
              body: PageView(
                physics: NeverScrollableScrollPhysics(),
                allowImplicitScrolling: false,
                controller: _pageController,
                children: <Widget>[
                  HomeTab(),
                  //VideoTab(),
                  //SearchTab(scaffoldKey: scaffoldKey,),
                  BookmarkTab(),
                  SettingPage()
                ],
              ),
          ),
    );
  }

  AnimatedBottomNavigationBar _bottonNavigationBar(BuildContext context) {
    return AnimatedBottomNavigationBar(
      icons: iconList,
      gapLocation: GapLocation.none,
      activeIndex: selectedIndex,
      iconSize: 22,
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      activeColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      inactiveColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      splashColor: Theme.of(context).primaryColor,
      onTap: (index) => onItemTapped(index),
      height: 45,
    );
  }

}
