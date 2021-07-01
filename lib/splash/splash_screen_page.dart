import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rash_decision/base/constants.dart';
import 'package:rash_decision/base/routes.dart';
import 'package:rash_decision/base/theme/art.dart';
import 'package:rash_decision/splash/splash_selector_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  SharedPreferences sharedPreferences;
  bool loginState = false;

  Future<bool> setSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(Constants.IS_RASH_DECISION_LOGIN);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      Constants.screenHeight = MediaQuery.of(context).size.height;
      Constants.screenWidth = MediaQuery.of(context).size.width;
    }
  }

  @override
  void initState() {
    super.initState();
    setSharedPref().then((value) {
      if (value == null) {
        value = false;
      }
      loginState = value;
      Future.delayed(Duration(seconds: 3), () {
        if (loginState) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.HOME_PAGE);
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SplashSelectorPage(),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            Images.BG_IMG,
            fit: BoxFit.cover,
            height: Constants.screenHeight,
            width: Constants.screenWidth,
          ),
          Image.asset(
            Images.IC_SPLASH,
//            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            top: MediaQuery.of(context).size.width * 0.3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Image.asset(
                Images.LOGO_NAME_IMG,
                fit: BoxFit.cover,
                height: Constants.screenWidth * 0.5,
                width: Constants.screenWidth * 0.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}
