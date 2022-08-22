import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/full_image.dart';
import "package:wordpress_app/widgets/iframe_youtube_player_widget.dart";
import 'package:wordpress_app/widgets/local_video_player.dart';

class HtmlBody extends StatelessWidget {

  final String content;
  final bool isVideoEnabled;
  final bool isimageEnabled;
  final bool isIframeVideoEnabled;
  final double? textPadding;
  const HtmlBody({Key? key, required this.content, required this.isVideoEnabled, required this.isimageEnabled, required this.isIframeVideoEnabled, this.textPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: content,
      onLinkTap: (String? url, RenderContext context1, Map<String, String> attributes, _) {
        AppService().openLinkWithBrowserMiniProgram(context, url!);
      },
      onImageTap: (String? url, RenderContext context1, Map<String, String> attributes, _) {
        nextScreen(context, FullScreenImage(imageUrl: url!));
      },
      style: {
        "body": Style(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            fontSize: FontSize(17.0),
            lineHeight: LineHeight(1.4),
            whiteSpace: WhiteSpace.NORMAL,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.secondary,
            fontFamily: ''),
        "p,h1,h2,h3,h4,h5,h6": Style(margin: EdgeInsets.all(textPadding == null ? 20.0 : textPadding!)),
        "figure": Style(margin: EdgeInsets.zero, padding: EdgeInsets.zero),
      },
      customRender: {
        "video": (RenderContext context1, Widget child) {
          if(isVideoEnabled == false) return Container();
          //return LocalVideoPlayer(videoUrl: context1.tree.element!.attributes['src'].toString());
        },

        "img": (RenderContext context1, Widget child){
          final String _imageSource = context1.tree.element!.attributes['src'].toString();
          if(isimageEnabled == false) return Container();
          return InkWell(
            child: CachedNetworkImage(imageUrl: _imageSource),
            onTap: ()=> nextScreen(context, FullScreenImage(imageUrl: _imageSource)),
          );
        },

      },
    );
  }
}
