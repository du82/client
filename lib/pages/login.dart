import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/models/user.dart';
import 'package:wordpress_app/pages/done.dart';
import 'package:wordpress_app/pages/create_account.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/snacbar.dart';
import '../models/icon_data.dart';
import '../services/auth_service.dart';
import '../utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.popUpScreen}) : super(key: key);

  final bool? popUpScreen;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var userNameCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  final _btnController = new RoundedLoadingButtonController();

  bool offsecureText = true;
  Icon lockIcon = LockIcon().lock;


  Future _handleLoginWithUsernamePassword () async {
    final UserBloc ub = context.read<UserBloc>();
    if(userNameCtrl.text.isEmpty){
      _btnController.reset();
      openSnacbar(scaffoldKey, 'Username is required');
    }else if(passwordCtrl.text.isEmpty){
      _btnController.reset();
      openSnacbar(scaffoldKey, 'Password is required');
    }else{
      AppService().checkInternet().then((hasInternet)async {
        if(!hasInternet!){
          _btnController.reset();
          openSnacbar(scaffoldKey, 'no internet'.tr());
        }else {
          await AuthService().loginWithUsernamePassword(userNameCtrl.text, passwordCtrl.text)
              .then((UserModel? userModel){
            if(userModel != null){
              ub.guestUserSignout()
                  .then((value) => ub.saveUserData(userModel))
                  .then((value) => ub.setSignIn()).then((value){
                _btnController.success();
                print(userModel.id);
                afterSignIn();
              });


            }else{
              _btnController.reset();
              openSnacbar(scaffoldKey, 'Username or password is invalid');
            }
          });
        }
      });
    }
  }

  void _onlockPressed() {
    if (offsecureText == true) {
      setState(() {
        offsecureText = false;
        lockIcon = LockIcon().open;
      });
    } else {
      setState(() {
        offsecureText = true;
        lockIcon = LockIcon().lock;
      });
    }
  }



  void afterSignIn() async {
    if(widget.popUpScreen == null || widget.popUpScreen == false){
      nextScreen(context, DonePage());

    }else{
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(
                    left: 5,
                    right: 5
                ),
                child: Icon(
                  Feather.chevron_left,
                  size: 30,
                ),
              ),
              onPressed: ()=> Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 30, right: 30, top: 150, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'login',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600,
                letterSpacing: -0.7, wordSpacing: 1,
              ),
            ).tr(),
            SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username/Email',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, wordSpacing: 1, letterSpacing: -0.7),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(top: 10, bottom: 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Enter your username or email',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Feather.at_sign,
                          size: 20,
                        )),
                    controller: userNameCtrl,
                    keyboardType: TextInputType.text,
                  ),
                ),
                Text(
                  'Password',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, wordSpacing: 1, letterSpacing: -0.7),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Enter password',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                            icon: lockIcon,
                            onPressed: () => _onlockPressed()),
                        prefixIcon: Icon(
                          Feather.lock,
                          size: 20,
                        )),
                    controller: passwordCtrl,
                    obscureText: offsecureText,
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),


                RoundedLoadingButton(
                  animateOnTap: true,
                  child: Wrap(
                    children: [
                      Text(
                        'login',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ).tr()
                    ],
                  ),
                  controller: _btnController,
                  onPressed: () => _handleLoginWithUsernamePassword(),
                  width: MediaQuery.of(context).size.width * 1.0,
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                ),
                SizedBox(
                  height: 20,
                ),
                RoundedLoadingButton(
                  animateOnTap: true,
                  child: Wrap(
                    children: [


                      Text(
                        'Create Account',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                        ),
                      ).tr()
                    ],
                  ),
                  controller: _btnController,
                  onPressed: () => nextScreenReplace(context, CreateAccountPage(popUpScreen: widget.popUpScreen,)),
                  width: MediaQuery.of(context).size.width * 1.0,
                  color: Config().appSecondaryColor,
                  elevation: 0,
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
