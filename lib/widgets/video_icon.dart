import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:wordpress_app/config/server_config.dart';

class VideoIcon extends StatelessWidget {
  final List? tags;
  final double iconSize;
  const VideoIcon({Key? key, required this.tags, required this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tags == null || !tags!.contains(WpConfig.videoTagId))
      return Container();
    else
      /*return Align(
        alignment: Alignment.center,
        child: Icon(Icons.play_circle_fill_outlined,
            color: Colors.white, size: iconSize),
      );*/
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.only(left: 8),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          //color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.7),
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(100)
        ),
        child: Align(
          alignment: Alignment.center,
          child: Icon(
            LucideIcons.play,
            color: Theme.of(context).colorScheme.background,
            size: 40,
          ),
        )


        /*Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Feather.plus_circle,
              color: Theme.of(context).colorScheme.background,
              size: 40,
            ),
          ],
        ),*/
      ),
    );
  }
}
