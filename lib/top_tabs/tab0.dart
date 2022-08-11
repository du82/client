import 'package:flutter/material.dart';
import 'package:wordpress_app/config/server_config.dart';
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
    return SingleChildScrollView(
      key: PageStorageKey('key0'),
      padding: EdgeInsets.all(0),
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          //Featured(),
          /*Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.red[400], borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      ' The app is running in developer mode.\n The lag seen here wont be in the official release.',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context)
                              .backgroundColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),*/
          //Featured(),
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
    );
  }
}