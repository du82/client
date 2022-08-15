import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wikidart/wikidart.dart';

import '../services/app_service.dart';

class SearchHintWikipedia extends StatefulWidget {
  const SearchHintWikipedia({Key? key, required this.request}) : super(key: key);
  final String request;

  Future<void> main() async {
    var res = await Wikidart.searchQuery(request);
    var pageid = res?.results?.first.pageId;

    if (pageid != null) {
      var google = await Wikidart.summary(pageid);

      print(google?.title); // Returns "Google"
      print(google?.description); // Returns "American technology company"
      print(google?.extract); // Returns "Google LLC is an American multinational technology company that specializes in Internet-related..."
    }
  }

  @override
  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<SearchHintWikipedia> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 3),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              isThreeLine: false,
              leading: CircleAvatar(
                backgroundColor: Colors.blue[900],
                radius: 20,
                child: Icon(
                  LucideIcons.languages,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              title: Row(
                children: [
                  Text(
                    'translate query title',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ).tr(),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background.withOpacity(1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            width: 0.7
                        )
                    ),
                    child: Row(
                      children: [
                        Text(
                          'MP',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          ),
                        ).tr(),
                      ],
                    ),
                  ),
                ],
              ),
              subtitle: Container(
                padding: EdgeInsets.only(top: 5),
                child: Container(),
              ),
            ),
          ),
          Container(height: 10,),
          InkWell(
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(height: 35, decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(8),
                  ), child: Center(
                    child: Text(
                      'translate query button',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ).tr(),
                  ),
                  )
              ),
              onTap: () {
                AppService().openLinkWithBrowserMiniProgram(
                    context, ("https://www.deepl.com/translator#en/de/" + widget.request));
                HapticFeedback.heavyImpact();
              }
          ),
        ],
      ),
    );
  }
}