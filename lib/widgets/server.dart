import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../config/config.dart';

class ServerPopup extends StatefulWidget {
  const ServerPopup({Key? key}) : super(key: key);

  @override
  _ServerPopupState createState() => _ServerPopupState();
}

class _ServerPopupState extends State<ServerPopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        title: Text('Select Homeserver').tr(),
        centerTitle: true,
        leading: Container(),
        toolbarHeight: 45,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                ),
                child: Icon(
                  Feather.chevron_left,
                  size: 32,
                ),
              ),
              onPressed: ()=> Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: Config.servers.length,
        itemBuilder: (BuildContext context, int index) {
          return _itemList(Config.servers[index], index);
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
            leading: Icon(Feather.server, size: 22,),
            horizontalTitleGap: 10,
            title: Text(d, style: TextStyle(
                fontWeight: FontWeight.w500
            ),),
            onTap: () async {
              if(d == '311310.com'){
                await context.setLocale(Locale('en'));
              }
              else if(d == 'baishi.io'){
                await context.setLocale(Locale('zh'));
              }
              else if(d == 'Spanish'){
                await context.setLocale(Locale('es'));
              }
              Navigator.pop(context);
            },
          ),
        ),

      ],
    );
  }
}
