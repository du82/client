
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordpress_app/models/user.dart';

class UserBloc extends ChangeNotifier {

  
  UserBloc() {
    checkSignIn();
    checkGuestUser();
  }

  bool _guestUser = false;
  bool get guestUser => _guestUser;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;


  String? _userName;
  String? get name => _userName;

  int? _id;
  int? get uid => _id;

  String? _email;
  String? get email => _email;

  String? _avatarUrl;
  String? get avatarUrl => _avatarUrl;




  Future saveUserData(UserModel userModel) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setInt('id', userModel.id!);
    await sp.setString('user_name', userModel.userName!);
    await sp.setString('email', userModel.userEmail!);
    _id = userModel.id;
    _userName = userModel.userName;
    _email = userModel.userEmail;
    notifyListeners();
    
  }



  Future getUserData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _id = sp.getInt('id');
    _userName = sp.getString('user_name');
    _email = sp.getString('email');
    _avatarUrl = sp.getString('avatar_urls');
    notifyListeners();
  }




  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    _isSignedIn = true;
    notifyListeners();
  }



  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed_in') ?? false;
    notifyListeners();
  }



  Future userSignout() async {
    await clearAllUserData()
    .then((value){
      _isSignedIn = false;
      _guestUser = false;
      _userName = null;
      _email = null;
      _id = null;
      notifyListeners();
      
    });
  }

  



  Future loginAsGuestUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('guest_user', true);
    _guestUser = true;
    notifyListeners();
  }



  void checkGuestUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _guestUser = sp.getBool('guest_user') ?? false;
    notifyListeners();
  }




  Future clearAllUserData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();

  }





  Future guestUserSignout() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('guest_user', false);
    _guestUser = false;
    notifyListeners();
  }




}