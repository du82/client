import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/src/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:wikidart/wikidart.dart';
import 'package:wordpress_app/blocs/category_bloc.dart';
import 'package:wordpress_app/cards/card5.dart';
import 'package:wordpress_app/config/server_config.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/category.dart';
import 'package:wordpress_app/models/constants.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import 'package:wordpress_app/utils/cached_image_with_dark.dart';
import 'package:wordpress_app/utils/empty_icon.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/utils/snacbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordpress_app/cards/search_cards/search_hint_qrcode.dart';
import 'package:wordpress_app/cards/search_cards/search_hint_webpage.dart';

import '../cards/search_cards/search_hint_create.dart';
import '../cards/search_cards/search_hint_translate.dart';
import 'category_based_articles.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var searchFieldCtrl = TextEditingController();
  bool _searchStarted = false;

  Future? data;

  get itemBuilder => null;

  get query => null;

  Future<void> main() async {
    var res = await Wikidart.searchQuery(searchFieldCtrl.text);
    var pageid = res?.results?.first.pageId;

    if (pageid != null) {
      var google = await Wikidart.summary(pageid);

      print(google?.title); // Returns "Google"
      print(google?.description); // Returns "American technology company"
      print(google?.extract); // Returns "Google LLC is an American multinational technology company that specializes in Internet-related..."
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: _searchBar(),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: 40.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 10, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '.com',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + ".com";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '.net',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + ".net";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '.org',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + ".org";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '.me',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + ".me";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '.io',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + ".io";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '.co',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + ".co";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        'http://',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "http://" + searchFieldCtrl.text;
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        'https://',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "https://" + searchFieldCtrl.text;
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '/',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + "/";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        'Translate',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  /*onTap: (){
                    searchFieldCtrl.text = "https://" + searchFieldCtrl.text;
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },*/
                  onTap: (){
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://www.deepl.com/translator#en/de/" + searchFieldCtrl.text));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '+',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + "+";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '−',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + "-";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '×',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + "×";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '÷',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + "÷";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        'π',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + "π";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '(  )',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "(" + searchFieldCtrl.text + ")";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '{  }',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "{" + searchFieldCtrl.text + "}";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '[  ]',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "[" + searchFieldCtrl.text + "]";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '< >',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = "<" + searchFieldCtrl.text + ">";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '\$',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + "\$";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '£',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + "£";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '€',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + "€";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '¥',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + "¥";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 5, top: 5, right: 15, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                      child: Text(
                        '₹',
                        maxLines: 1,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ),
                  onTap: (){
                    searchFieldCtrl.text = searchFieldCtrl.text + "₹";
                    searchFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: searchFieldCtrl.text.length));
                  },
                ),
              ],
            ),
          ),
        ),
        elevation: 0,
        leadingWidth: 15,
        leading: Container(),
      ),
      key: scaffoldKey,
      body: Container(
        color: Theme.of(context).colorScheme.onSecondary,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 15),
                    child: Column(
                      children: [
                        _searchStarted == false
                            ? _suggestionUI()
                            : _afterSearchUI(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            InkWell(
              child: IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(
                      left: 5,
                      right: 0
                  ),
                  child: Icon(
                    LucideIcons.chevronLeft,
                    size: 32,
                  ),
                ), onPressed: () {Navigator.pop(context);},
              ),
              onLongPress: () => Navigator.of(context).popUntil((route) => route.isFirst),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.transparent),
        child: Stack(
          children: [
            Container(
              height: 40,
              margin: EdgeInsets.only(right: 15, top: 5),
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.3
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                autofocus: true,
                maxLines: 1,
                maxLength: 250,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                controller: searchFieldCtrl,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "search contents".tr(),
                  counterText: "",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  suffix: InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Icon(
                        LucideIcons.xCircle,
                        size: 18,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _searchStarted = false;
                      });
                      searchFieldCtrl.clear();
                    },
                  ),
                  suffixIcon: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(left: 8, top: 10, right: 10, bottom: 8),
                      alignment: Alignment.center,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Text(
                          'Go',
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: -0.7,
                              wordSpacing: 1,
                              fontSize: 16,
                              color: Theme.of(context).backgroundColor,
                              fontWeight: FontWeight.w500),
                        ).tr(),
                      ),
                    ),

                    onTap: (){
                      AppService().addToRecentSearchList(searchFieldCtrl.text);
                      if (searchFieldCtrl.text.contains("https://")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, searchFieldCtrl.text);
                      } else if (searchFieldCtrl.text.contains("http://")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, searchFieldCtrl.text);
                        // B - Baidu
                      } else if (searchFieldCtrl.text.startsWith("!bd ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://www.baidu.com/s?wd=" + searchFieldCtrl.text.replaceRange(0, 3, "")));
                        // D - DuckDuckGo
                      } else if (searchFieldCtrl.text.startsWith("!d ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://duckduckgo.com/?q=" + searchFieldCtrl.text.replaceRange(0, 2, "")));
                        // G - GitHub
                      } else if (searchFieldCtrl.text.startsWith("!gh ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://github.com/search?q=" + searchFieldCtrl.text.replaceRange(0, 3, "")));
                        // T - Toutiao
                      } else if (searchFieldCtrl.text.startsWith("!t ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://so.toutiao.com/search?keyword=" + searchFieldCtrl.text.replaceRange(0, 2, "")));
                        // O - Odysee
                      } else if (searchFieldCtrl.text.startsWith("!o ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://odysee.com/\$/search?q=" + searchFieldCtrl.text.replaceRange(0, 2, "")));
                        // S - SearXNG
                      } else if (searchFieldCtrl.text.startsWith("!s ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://s.zhaocloud.net/search?q=" + searchFieldCtrl.text.replaceRange(0, 2, "")));
                        // SO - Stack Overflow
                      } else if (searchFieldCtrl.text.startsWith("!so ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://stackoverflow.com/search?q=" + searchFieldCtrl.text.replaceRange(0, 3, "")));
                        // W - Wikipedia
                      } else if (searchFieldCtrl.text.startsWith("!w ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://wikipedia.org/wiki/" + searchFieldCtrl.text.replaceRange(0, 2, "")));
                      } else if (searchFieldCtrl.text.startsWith("!wa ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://www.wolframalpha.com/input?i=" + searchFieldCtrl.text.replaceRange(0, 3, "")));
                        // X - Xigua Video
                      } else if (searchFieldCtrl.text.startsWith("!x ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://www.ixigua.com/search/" + searchFieldCtrl.text.replaceRange(0, 2, "")));
                        // Y - YouTube
                      } else if (searchFieldCtrl.text.startsWith("!yt ")) {
                        AppService().openLinkWithBrowserMiniProgram(
                            context, ("https://www.youtube.com/results?search_query=" + searchFieldCtrl.text.replaceRange(0, 3, "")));

                      } else if (searchFieldCtrl.text.startsWith("!mp ")) {
                        AppService().openLinkWithRenderMiniProgram(
                            context, (searchFieldCtrl.text.replaceRange(0, 3, "")));
                      } else {
                        if (searchFieldCtrl.text.contains(".com") ||
                            searchFieldCtrl.text.contains(".net") ||
                            searchFieldCtrl.text.contains(".org") ||
                            searchFieldCtrl.text.contains(".dev") ||
                            searchFieldCtrl.text.contains(".gov") ||
                            searchFieldCtrl.text.contains(".xyz") ||
                            searchFieldCtrl.text.contains(".xyz") ||
                            searchFieldCtrl.text.contains(".io") ||
                            searchFieldCtrl.text.contains(".me") ||
                            searchFieldCtrl.text.contains(".im") ||
                            searchFieldCtrl.text.contains(".co") ||
                            searchFieldCtrl.text.contains(".cn")) {
                          AppService().openLinkWithBrowserMiniProgram(
                              context, ("https://" + searchFieldCtrl.text));
                        }
                      }

                      setState(() => _searchStarted = true);
                      data = TenwanService().fetchPostsBySearch(searchFieldCtrl.text);},
                  ),
                ),

                textInputAction: TextInputAction.search,
                onFieldSubmitted: (query) {
                  if (query == '' || query.isEmpty) {
                    openSnacbar(scaffoldKey, 'Type something');
                  } else {
                    setState(() => _searchStarted = true);
                    data = TenwanService().fetchPostsBySearch(searchFieldCtrl.text);
                    AppService().addToRecentSearchList(query);
                  }
                  if (query.contains("https://")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, query);
                  } else if (query.contains("http://")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, query);
                    // B - Baidu
                  } else if (query.startsWith("!bd ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://www.baidu.com/s?wd=" + query.replaceRange(0, 3, "")));
                    // D - DuckDuckGo
                  } else if (query.startsWith("!d ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://duckduckgo.com/?q=" + query.replaceRange(0, 2, "")));
                    // G - GitHub
                  } else if (query.startsWith("!gh ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://github.com/search?q=" + query.replaceRange(0, 3, "")));
                    // T - Toutiao
                  } else if (query.startsWith("!t ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://so.toutiao.com/search?keyword=" + query.replaceRange(0, 2, "")));
                    // O - Odysee
                  } else if (query.startsWith("!o ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://odysee.com/\$/search?q=" + query.replaceRange(0, 2, "")));
                    // S - SearXNG
                  } else if (query.startsWith("!s ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://s.zhaocloud.net/search?q=" + query.replaceRange(0, 2, "")));
                    // SO - Stack Overflow
                  } else if (query.startsWith("!so ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://stackoverflow.com/search?q=" + query.replaceRange(0, 3, "")));
                    // W - Wikipedia
                  } else if (query.startsWith("!w ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://wikipedia.org/wiki/" + query.replaceRange(0, 2, "")));
                  } else if (query.startsWith("!wa ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://www.wolframalpha.com/input?i=" + query.replaceRange(0, 3, "")));
                    // X - Xigua Video
                  } else if (query.startsWith("!x ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://www.ixigua.com/search/" + query.replaceRange(0, 2, "")));
                    // Y - YouTube
                  } else if (query.startsWith("!yt ")) {
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://www.youtube.com/results?search_query=" + query.replaceRange(0, 3, "")));

                  } else if (query.startsWith("!mp ")) {
                    AppService().openLinkWithRenderMiniProgram(
                        context, (query.replaceRange(0, 3, "")));
                  } else {
                    if (query.contains(".com") ||
                        query.contains(".net") ||
                        query.contains(".org") ||
                        query.contains(".dev") ||
                        query.contains(".gov") ||
                        query.contains(".xyz") ||
                        query.contains(".xyz") ||
                        query.contains(".io") ||
                        query.contains(".me") ||
                        query.contains(".im") ||
                        query.contains(".co") ||
                        query.contains(".cn")) {
                      AppService().openLinkWithBrowserMiniProgram(
                          context, ("https://" + query));
                    }
                  }
                },
              ),
            ),
          ],
        )
    );
  }

  Widget _afterSearchUI() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: data,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return _LoadingWidget();
                case ConnectionState.done:
                default:
                  if (snapshot.hasError || snapshot.data == null) {
                    return EmptyPageWithIcon(
                        icon: Icons.error, title: 'Error!');
                  } else if (snapshot.data.isEmpty) {
                    return Column(
                      children: [
                        if (searchFieldCtrl.text.contains('scan') || searchFieldCtrl.text.contains('qr') || searchFieldCtrl.text.contains('code'))
                          SearchHintQRcode(),
                        if (searchFieldCtrl.text.startsWith('create') || searchFieldCtrl.text.startsWith('test'))
                          SearchHintCreator(),
                        if (searchFieldCtrl.text.startsWith('translate') || searchFieldCtrl.text.startsWith('tr'))
                          SearchHintTranslate(request: searchFieldCtrl.text,),
                        if (searchFieldCtrl.text.contains('.com')
                            || searchFieldCtrl.text.contains('.net')
                            || searchFieldCtrl.text.contains('.org')
                            || searchFieldCtrl.text.contains('.me')
                            || searchFieldCtrl.text.contains('.co')
                            || searchFieldCtrl.text.contains('.io')
                            || searchFieldCtrl.text.contains('.cn')
                            || searchFieldCtrl.text.contains('.dev'))
                          SearchHintWebpage(url: searchFieldCtrl.text,),
                        _searchProviderUI()
                      ],
                    );
                  }
                  return Column(
                    children: [
                      if (searchFieldCtrl.text.startsWith('translate') || searchFieldCtrl.text.startsWith('tr'))
                        SearchHintTranslate(request: searchFieldCtrl.text,),
                      if (searchFieldCtrl.text.contains('scan') || searchFieldCtrl.text.contains('qr') || searchFieldCtrl.text.contains('code'))
                        SearchHintQRcode(),
                      if (searchFieldCtrl.text.contains('.com')
                          || searchFieldCtrl.text.contains('.net')
                          || searchFieldCtrl.text.contains('.org')
                          || searchFieldCtrl.text.contains('.me')
                          || searchFieldCtrl.text.contains('.co')
                          || searchFieldCtrl.text.contains('.io')
                          || searchFieldCtrl.text.contains('.cn')
                          || searchFieldCtrl.text.contains('.dev'))
                        SearchHintWebpage(url: searchFieldCtrl.text,),
                      ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          separatorBuilder: (ctx, idx) => Container(height: 10,),
                          itemBuilder: (BuildContext context, int index) {
                            Article article = snapshot.data[index];
                            return Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 0, top: 0, bottom: 0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Card5(
                                article: article,
                                heroTag: 'search${article.id}',
                                scaffoldKey: scaffoldKey));
                          }),
                      Container(height: 10),
                      _searchProviderUI(),
                      Container(height: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: (
                              Text(
                                '~~  Search results provided by baishi.io  ~~',
                                maxLines: 1,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    letterSpacing: -0.7,
                                    wordSpacing: 1,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ).tr()
                          ),
                        ),
                      )
                    ],
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _suggestionUI() {
    final recentSearchs = Hive.box(Constants.resentSearchTag);
    final d = context.watch<CategoryBloc>().categoryData;
    return recentSearchs.isEmpty
        ? _EmptySearchAnimation()
        : Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'recent searches'.tr(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 15,
          ),
          ValueListenableBuilder(
            valueListenable: recentSearchs.listenable(),
            builder: (BuildContext context, dynamic value, Widget? child) {
              return ListView.separated(
                itemCount: recentSearchs.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                        horizontalTitleGap: 5,
                        title: Text(
                          recentSearchs.getAt(index),
                          style: TextStyle(fontSize: 17),
                        ),
                        trailing: IconButton(
                          icon: Icon(LucideIcons.trash2),
                          onPressed: () => AppService()
                              .removeFromRecentSearchList(index),
                        ),
                        onTap: () {
                          setState(() => _searchStarted = true);
                          searchFieldCtrl.text =
                              recentSearchs.getAt(index);
                          data = TenwanService()
                              .fetchPostsBySearch(searchFieldCtrl.text);
                        }),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _searchProviderUI() {
    final recentSearchs = Hive.box(Constants.resentSearchTag);
    final d = context.watch<CategoryBloc>().categoryData;
    return recentSearchs.isEmpty
        ? _EmptySearchAnimation()
        : Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              'try alt search',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700),
            ).tr(),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: InkWell(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 5, right: 5, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(height: 35, decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.circular(8),
                      ), child: Center(
                        child: Text(
                          'duck duck go',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ).tr(),
                      ),
                    )
                  ),
                  onTap: (){
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://duckduckgo.com/?q=" + searchFieldCtrl.text));
                  },
                ),
              ),
              Expanded(
                flex: 5,
                child: InkWell(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 5, right: 0, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(height: 35, decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.circular(8),
                      ), child: Center(
                        child: Text(
                          'github',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ).tr(),
                      ),
                      )
                  ),
                  onTap: (){
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://github.com/search?q=" + searchFieldCtrl.text));
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: InkWell(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 5, right: 5, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(height: 35, decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.circular(8),
                      ), child: Center(
                        child: Text(
                          'wikipedia',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ).tr(),
                      ),
                      )
                  ),
                  onTap: (){
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://wikipedia.org/wiki/" + searchFieldCtrl.text));
                  },
                ),
              ),
              Expanded(
                flex: 5,
                child: InkWell(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 5, right: 0, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(height: 35, decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.circular(8),
                      ), child: Center(
                        child: Text(
                          'reddit',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ).tr(),
                      ),
                      )
                  ),
                  onTap: (){
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://www.reddit.com/search/?q=" + searchFieldCtrl.text));
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: InkWell(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 5, right: 5, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(height: 35, decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.circular(8),
                      ), child: Center(
                        child: Text(
                          'youtube',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ).tr(),
                      ),
                      )
                  ),
                  onTap: (){
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://www.youtube.com/results?search_query=" + searchFieldCtrl.text));
                  },
                ),
              ),
              Expanded(
                flex: 5,
                child: InkWell(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 5, right: 0, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(height: 35, decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.circular(8),
                      ), child: Center(
                        child: Text(
                          'odysee',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ).tr(),
                      ),
                      )
                  ),
                  onTap: (){
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://odysee.com/\$/search?q=" + searchFieldCtrl.text));
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: InkWell(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 5, right: 5, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(height: 35, decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.circular(8),
                      ), child: Center(
                        child: Text(
                          'wolfram alpha',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ).tr(),
                      ),
                      )
                  ),
                  onTap: (){
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://www.wolframalpha.com/input?i=" + searchFieldCtrl.text));
                  },
                ),
              ),
              Expanded(
                flex: 5,
                child: InkWell(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 5, right: 0, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(height: 35, decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.circular(8),
                      ), child: Center(
                        child: Text(
                          'searx',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ).tr(),
                      ),
                      )
                  ),
                  onTap: (){
                    AppService().openLinkWithBrowserMiniProgram(
                        context, ("https://s.zhaocloud.net/search?q=" + searchFieldCtrl.text));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        separatorBuilder: (context, index) => SizedBox(
          height: 15,
        ),
        itemBuilder: (BuildContext context, int index) {
          return LoadingCard(height: 110);
        });
  }
}

class _EmptySearchAnimation extends StatelessWidget {
  const _EmptySearchAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
        ),
        Text('search for content', style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.7,
            wordSpacing: 1
        ),).tr(),

        SizedBox(height: 10,),

        Text('search description',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary
          ),).tr(),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final Category d;
  const _CategoryItem({Key? key, required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final String _heroTag = 'category${d.id}';
    final String _thumbnail = WpConfig.categoryThumbnails.keys.contains(d.id)
        ? WpConfig.categoryThumbnails[d.id]
        : WpConfig.randomCategoryThumbnail;

    return InkWell(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Hero(
              tag: _heroTag,
              child: CustomCacheImageWithDarkFilterBottom(
                imageUrl: _thumbnail,
                radius: 8,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${d.name!.toUpperCase()}",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      onTap: () {
        nextScreen(
            context,
            CategoryBasedArticles(
              categoryName: d.name,
              categoryId: d.id,
              categoryThumbnail: _thumbnail,
              heroTag: _heroTag,
            ));
      },
    );
  }
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