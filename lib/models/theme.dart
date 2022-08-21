import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordpress_app/config/config.dart';


class ThemeModel {
  final lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primarySwatch: Colors.red,
    primaryColor: Config().appThemeColor,
    backgroundColor: Colors.white,
    // scaffoldBackgroundColor: Colors.grey[100],
    scaffoldBackgroundColor: Colors.white,
    shadowColor: Colors.grey[200],
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    brightness: Brightness.light,
    fontFamily: 'Manrope',
    colorScheme: ColorScheme.light(
        primary: Colors.black, //text
        secondary: Colors.grey[500]!, //text
        onPrimary: Colors.white, //card -1
        onSecondary: Colors.grey[100]!, //card -2
        primaryVariant: Colors.grey[200]!, //card color -3
        secondaryVariant: Colors.grey[300]!, //card color -4
        surface: Colors.grey[300]!, //shadow color -1
        onBackground: Colors.grey[300]! //loading card color
    ),

    dividerColor: Colors.grey[100],
    iconTheme: IconThemeData(color: Colors.grey[900]),
    primaryIconTheme: IconThemeData(
      color: Colors.grey[900],
    ),

    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.7,
          color: Colors.grey[900]),
      iconTheme: IconThemeData(color: Colors.grey[900]),
      actionsIconTheme: IconThemeData(color: Colors.grey[900]),
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Config().appThemeColor,
      unselectedItemColor: Colors.blueGrey[200],
    ),

    popupMenuTheme: PopupMenuThemeData(
      textStyle: TextStyle(
          fontFamily: 'Manrope',
          color: Colors.grey[900],
          fontWeight: FontWeight.w500
      ),
    ),
  );





  final darkTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: Config().appThemeColor,
    backgroundColor: Colors.grey[900],
    scaffoldBackgroundColor: Colors.grey[900],
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    shadowColor: Colors.grey[900],
    brightness: Brightness.dark,
    fontFamily: 'Manrope',
    dividerColor: Colors.grey[800],
    iconTheme: IconThemeData(color: Colors.white),
    primaryIconTheme: IconThemeData(
      color: Colors.white,
    ),
    appBarTheme: AppBarTheme(
        color: Colors.grey[900]!,
        elevation: 0,
        textTheme: TextTheme(
            headline6: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.7,
                color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        brightness: Brightness.dark),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[900],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[600],
    ),

    popupMenuTheme: PopupMenuThemeData(
      textStyle: TextStyle(
          fontFamily: 'Manrope',
          color: Colors.white,
          fontWeight: FontWeight.w500
      ),
    ), colorScheme: ColorScheme.dark(
        primary: Colors.grey[900]!, //text
        secondary: Colors.grey[600]!, //text
        onPrimary: Color(0xFF121212), //card color -1
        onSecondary: Colors.grey[900]!, //card color -2
        primaryVariant: Colors.grey[850]!, //card color -3
        secondaryVariant: Colors.grey[900]!, //card color -4
        surface: Color(0xff303030), //shadow color - 1
        onBackground: Colors.grey[900]!  //loading card color

    ).copyWith(primary: Colors.grey[700], secondary: Color(0xFF32373c)),
  );
}
