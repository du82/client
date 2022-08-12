import 'package:flutter/material.dart';

class HeaderBanner extends StatefulWidget {
  const HeaderBanner({Key? key, required this.title, required this.enabled}) : super(key: key);
  final String? title;
  final bool? enabled;
  @override
  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<HeaderBanner> {

  @override
  Widget build(BuildContext context) {
    if (widget.enabled == true)
    return Container(
      //height: 35,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.red[400],
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)
        ),
      ),
      child: Center(
        child: Text(
          widget.title!,
          style: TextStyle(
              fontSize: 15,
              color: Theme.of(context)
                  .backgroundColor,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
    else;
      return Container();
  }
}

