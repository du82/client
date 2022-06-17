import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/pages/home.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import '../config/config.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {


  void _onSkipPressed() async {
    final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
    await ub.loginAsGuestUser().then((_) {
      nextScreen(context, HomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        /*appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            elevation: 0,
            leading: Container(),
            actions: [
              TextButton(
                style: ButtonStyle(),
                child: Text(
                  'skip',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ).tr(),
                onPressed: () => _onSkipPressed(),
              ),
              IconButton(
                alignment: Alignment.center,
                padding: EdgeInsets.all(0),
                iconSize: 18,
                icon: Icon(Feather.globe),
                onPressed: () {
                  nextScreen(context, LanguagePopup());
                },
              ),
            ],
          ),
        ),*/
        body: Row(
          children: [
            Container(
              width: 10,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.redAccent,
                      Colors.orangeAccent,
                      Colors.yellowAccent,
                      Colors.greenAccent,
                      Colors.blueAccent,
                      Colors.purpleAccent,
                    ],
                  )
              ),
            ),
            Container(
              height: double.infinity,
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage(Config.splash),
                            height: 100,
                          ),
                          SizedBox(
                            height: 80,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 35, right: 35, top: 30),
                                child: Text(
                                  'Swipe from left to right where you see that fancy gradient to go to previous pages.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(context).colorScheme.secondary),
                                ).tr(),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 80,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0),
                                child: Text(
                                  '> > >',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      color:
                                      Theme.of(context).colorScheme.secondary),
                                ).tr(),
                              )
                            ],
                          ),
                        ],
                      )
                  ),

                  /*Spacer(),

                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery.of(context).size.width * 0.80,
                          height: 45,

                          child: TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                              )),
                              backgroundColor: MaterialStateProperty.resolveWith(
                                  (states) => Theme.of(context).primaryColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "login to continue",
                                  style: TextStyle(
                                      letterSpacing: -0.7,
                                      wordSpacing: 1,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ).tr(),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Feather.arrow_right,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            onPressed: () => nextScreen(context, LoginPage()),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "don't have an account?",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.secondary),
                            ).tr(),
                            TextButton(
                              child: Text(
                                'create',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.primary),
                              ).tr(),
                              onPressed: () =>
                                  nextScreen(context, CreateAccountPage()),
                            )
                          ],
                        )
                      ],
                    ),
                  ),*/


                ],
              ),
            ),
          ],
        )
    );
  }
}

