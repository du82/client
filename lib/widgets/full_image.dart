import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: InteractiveViewer(
            child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.contain,)
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(
                      left: 5,
                      right: 5
                  ),
                  child: Icon(
                    Feather.chevron_left,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                onPressed: ()=> Navigator.pop(context),
              ),
            ),
          ),
        )
      ],
    ));
  }
}