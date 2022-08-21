import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/models/auth_status.dart';
import 'package:wordpress_app/models/jwt_status.dart';
import 'package:wordpress_app/pages/done.dart';
import 'package:wordpress_app/pages/login.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/services/auth_service.dart';
import 'package:wordpress_app/utils/snacbar.dart';
import '../models/icon_data.dart';
import '../services/auth_service.dart';
import '../utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class CreateAccountPage extends StatefulWidget {
  CreateAccountPage({Key? key, this.popUpScreen}) : super(key: key);

  final bool? popUpScreen;

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var userNameCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  final _btnController = new RoundedLoadingButtonController();

  bool offsecureText = true;
  Icon lockIcon = LockIcon().lock;

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


  Future _handleCreateUser () async {
    final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
    if(userNameCtrl.text.isEmpty){
      _btnController.reset();
      openSnacbar(scaffoldKey, 'Username is required');
    }
    else if(emailCtrl.text.isEmpty){
      _btnController.reset();
      openSnacbar(scaffoldKey, 'Email is required');
    }
    else if(passwordCtrl.text.isEmpty){
      _btnController.reset();
      openSnacbar(scaffoldKey, 'Password is required');
    }
    else{
      AppService().checkInternet().then((hasInternet){
        if(!hasInternet!){
          _btnController.reset();
          openSnacbar(scaffoldKey, 'no internet'.tr());
        }else {
          AuthService().customAuthenticationViaJWT().then((JwtStatus? status)async{

            if(status == null || status.isSuccessfull == false){
              _btnController.reset();
              openSnacbar(scaffoldKey, 'JWT Authentication Error');
            }else{
              await AuthService().createUserWithUsernamePassword(status.urlHeader, userNameCtrl.text, emailCtrl.text, passwordCtrl.text)
                  .then((AuthStatus? authStatus)async{
                if(authStatus == null || authStatus.isSuccessfull == false){
                  _btnController.reset();
                  openSnacbar(scaffoldKey, authStatus!.errorMessage);
                }else{
                  await ub.guestUserSignout()
                      .then((value) => ub.saveUserData(authStatus.userModel!))
                      .then((value) => ub.setSignIn()).then((value){
                    _btnController.success();
                    afterSignUp();
                  });
                }
              });
            }
          });
        }
      });
    }
  }




  void afterSignUp() async {
    if(widget.popUpScreen == null || widget.popUpScreen == false){
      nextScreen(context, DonePage());

    }else{
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 30, right: 30, top: 150, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'create account',
              style: TextStyle(
                  letterSpacing: -0.7,
                  wordSpacing: 1,
                  fontSize: 22, fontWeight: FontWeight.w600),
            ).tr(),
            SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  'Username',
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
                        hintText: 'Enter username',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          LucideIcons.atSign,
                          size: 20,
                        )),
                    controller: userNameCtrl,
                    keyboardType: TextInputType.text,

                  ),
                ),

                Text(
                  'Email Address',
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
                        hintText: 'Enter email address',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          LucideIcons.mail,
                          size: 20,
                        )),
                    controller: emailCtrl,
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
                          LucideIcons.lock,
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
                        'create',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ).tr()
                    ],
                  ),
                  controller: _btnController,
                  onPressed: () => _handleCreateUser(),
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
                        'login',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                        ),
                      ).tr()
                    ],
                  ),
                  controller: _btnController,
                  onPressed: () => nextScreenReplace(context, LoginPage(popUpScreen: widget.popUpScreen,)),
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
