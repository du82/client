import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../config/config.dart';

class LanguagePopup extends StatefulWidget {
  const LanguagePopup({Key? key}) : super(key: key);

  @override
  _LanguagePopupState createState() => _LanguagePopupState();
}

class _LanguagePopupState extends State<LanguagePopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        title: Text('select language').tr(),
        centerTitle: true,
        leading: Container(),
        toolbarHeight: 45,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            InkWell(
              child: IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(
                      left: 0,
                      right: 0
                  ),
                  child: SvgPicture.asset('assets/icons/left.svg', width: 30,),
                ), onPressed: () {Navigator.pop(context);},
              ),
              onLongPress: () => Navigator.of(context).popUntil((route) => route.isFirst),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: Config.languages.length,
        itemBuilder: (BuildContext context, int index) {
          return _itemList(Config.languages[index], index);
        },
      ),
    );
  }

  Widget _itemList(d, index) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: 10, right: 10, top: 0, bottom: 0),
          margin: EdgeInsets.only(
              left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Icon(LucideIcons.globe, size: 22,),
            horizontalTitleGap: 10,
            title: Text(d, style: TextStyle(
                fontWeight: FontWeight.w500
            ),),
            onTap: () async {
              if(d == 'English • 英语'){
                await context.setLocale(Locale('en'));
              }
              else if(d == 'Chinese • 简体中文'){
                await context.setLocale(Locale('zh'));
              }
              else if(d == 'Spanish'){
                await context.setLocale(Locale('es'));
              }

              // else if(d == 'Your_Language_Name'){
              //   await context.setLocale(Locale('your_language_code'));
              // }
              Navigator.pop(context);
            },
          ),
        ),

      ],
    );
  }
}
