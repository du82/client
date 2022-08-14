import 'package:flutter/material.dart';
import 'package:wordpress_app/config/server_config.dart';
import 'package:wordpress_app/widgets/banner.dart';
import 'package:wordpress_app/widgets/featured.dart';
import 'package:wordpress_app/widgets/popular_articles.dart';
import '../blocs/featured_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/latest_articles_bloc.dart';
import '../blocs/popular_articles_bloc.dart';
import '../widgets/lattest_articles.dart';

class Tab0 extends StatefulWidget {

  Tab0({Key? key, required this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;


  @override
  _Tab0State createState() => _Tab0State();
}

class _Tab0State extends State<Tab0> {

  Future _onRefresh() async {
    context.read<FeaturedBloc>().saveDotIndex(0);
    context.read<FeaturedBloc>().fetchData();
    context.read<PopularArticlesBloc>().fetchData();
    context.read<LatestArticlesBloc>().onReload();
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,

      onRefresh: ()async => _onRefresh(),
      child: SingleChildScrollView(
        key: PageStorageKey('key0'),
        padding: EdgeInsets.all(0),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            //Featured(),

            HeaderBanner(title: 'The app is running in developer mode.', enabled: false,),

            PopularArticles(scaffoldKey: widget.scaffoldKey),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: Theme.of(context).dividerColor,
                thickness: 1.5,
                height: 20,
              ),
            ),
            LattestArticles(scaffoldKey: widget.scaffoldKey),
          ],
        ),
      ),
    );
  }
}