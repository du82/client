import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../../services/barcode_scanner.dart';

class SearchHintCreator extends StatelessWidget {
  const SearchHintCreator({
    Key? key,
  }) : super(key: key);

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

              title: Row(
                children: [
                  Text(
                    'Create for Bai, make \$10 per post!',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ).tr(),
                  Spacer(),
                  /*Container(
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
                  ),*/
                ],
              ),
              subtitle: Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  'Whatever you\'re passionate about, we want you to share it with our community, and pay you to do it!',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.secondary),
                ).tr(),
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
                      'Learn more',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                      ),
                    ).tr(),
                  ),
                  )
              ),
              onTap: () {
                Navigator.of(context).push(SwipeablePageRoute(canOnlySwipeFromEdge: true, builder: (BuildContext context) => BarcodeScannerWithController()));
                HapticFeedback.heavyImpact();
              }
          ),
          Container(height: 10,),
          InkWell(
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.greenAccent,
                          Colors.blueAccent,
                          Colors.purpleAccent,
                        ],
                      ),
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(8),
                  ), child: Center(
                    child: Text(
                      'Start creating',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ).tr(),
                  ),
                  )
              ),
              onTap: () {
                Navigator.of(context).push(SwipeablePageRoute(canOnlySwipeFromEdge: true, builder: (BuildContext context) => BarcodeScannerWithController()));
                HapticFeedback.heavyImpact();
              }
          ),
        ],
      ),
    );
  }
}