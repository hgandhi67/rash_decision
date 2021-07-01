import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:rash_decision/base/ads/app_ads.dart';
import 'package:rash_decision/base/appbar/app_bar.dart';
import 'package:rash_decision/base/constants.dart';
import 'package:rash_decision/base/routes.dart';
import 'package:rash_decision/base/theme/palette.dart';
import 'package:rash_decision/base/theme/styles.dart';
import 'package:rash_decision/model/disease_model.dart';
import 'package:rash_decision/widgets/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class RashResultSuccessPage extends StatefulWidget {
  final Diseases disease;
  final String imageUrl;
  final String dependentName;
  final imagePath;
  final String reportName;

  const RashResultSuccessPage({
    Key key,
    this.disease,
    this.imageUrl,
    this.dependentName,
    this.imagePath,
    this.reportName,
  }) : super(key: key);

  @override
  _RashResultSuccessPageState createState() => _RashResultSuccessPageState();
}

class _RashResultSuccessPageState extends State<RashResultSuccessPage> {
  Future<SharedPreferences> setSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
//    AppAds.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
//    Future.delayed(Duration(seconds: 2), (){
//      AppAds.init();
//      AppAds.showBanner(
//        anchorType: AnchorType.bottom,
//        childDirected: true,
//        listener: AppAds.bannerListener,
//        size: AdSize.fullBanner,
//      );
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Palette.white,
        appBar: AppBarWidget.getAppBarWidgetWithLeading(
          appBarTitle: Constants.REPORT_AND_ANALYSIS,
          context: context,
        ),
        body: Stack(
          children: <Widget>[
            Image.asset(
              'images/grayscale_bg.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 2.0,
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  width: Constants.screenWidth * 0.9,
                                  height: Constants.screenHeight * 0.35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: Palette.primaryColor,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                    child: Image.network(
                                      widget.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: new TextSpan(
                                    text: Constants.response_success_page_hint1,
//              style: DefaultTextStyle.of(context).style,
                                    style: Styles
                                        .termsAndConditionsContextTextStyle,
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text: 'non-cancerous.',
                                          style: new TextStyle(
                                            color: Colors.green[500],
                                            fontFamily: 'WorkSans',
                                            fontSize: 15,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  Constants.response_success_page_hint2,
                                  textAlign: TextAlign.center,
                                  style:
                                      Styles.termsAndConditionsContextTextStyle,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  Constants.response_success_page_hint3,
                                  textAlign: TextAlign.center,
                                  style: Styles.smallButtonTextStyle(
                                      color: Colors.black54),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  Constants.response_success_page_hint4,
                                  textAlign: TextAlign.center,
                                  style: Styles.smallButtonTextStyle(
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: GestureDetector(
                                          child: ButtonWidget(
                                            name: Constants.CONTINUE,
                                            bgColor: Palette.appBarBgColor,
                                            size: 16,
                                          ),
                                          onTap: () {
                                            //report page
                                            setSharedPref()
                                                .then((sharedPreferences) {
                                              Firestore.instance
                                                  .collection('disease')
                                                  .document(sharedPreferences
                                                      .getString(Constants
                                                          .LOGGED_IN_USER_ID))
                                                  .collection(sharedPreferences
                                                      .getString(Constants
                                                          .LOGGED_IN_USER_ID))
                                                  .document(widget.reportName)
                                                  .updateData({
                                                'is_opened': true,
                                              }).then((_) {
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                  AppRoutes.REPORT_ANALYSIS,
                                                  arguments: {
                                                    AppRouteArgKeys
                                                            .DISEASE_IMAGE_URL:
                                                        widget.imageUrl,
                                                    AppRouteArgKeys.DISEASE:
                                                        widget.disease,
                                                    AppRouteArgKeys
                                                            .DEPENDENT_NAME:
                                                        widget.dependentName,
                                                    AppRouteArgKeys
                                                            .REPORT_RASH_IMAGE_PATH:
                                                        widget.imagePath,
                                                    AppRouteArgKeys
                                                            .REPORT_RASH_CANCER:
                                                        'NotMelanoma',
                                                  },
                                                );
                                              }).catchError((onError) {
                                                Toast.show(
                                                    'Something went wrong, please try again.',
                                                    context);
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          child: ButtonWidget(
                                            name: Constants.NO_THANK_YOU,
                                            bgColor: Palette.lightRedColor,
                                            size: 16,
                                          ),
                                          onTap: () {
                                            //home page
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  Constants.response_success_page_hint5,
                                  textAlign: TextAlign.center,
                                  style: Styles.smallButtonTextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      AppRoutes.LEGAL_INFORMATION,
                                      arguments: {
                                        AppRouteArgKeys.LEGAL_INFO_PAGE_TITLE:
                                            Constants.terms_cond31,
                                        AppRouteArgKeys.LEGAL_INFO_PAGE_DATA:
                                            _getMedicalDisclaimerWidget(),
                                      },
                                    );
                                  },
                                  child: Text(
                                    Constants.terms_cond31,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Palette.primaryColorDark,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _getMedicalDisclaimerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          Constants.terms_cond32,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            Constants.terms_cond33,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond34,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            Constants.terms_cond35,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            Constants.terms_cond36,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond37,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            Constants.terms_cond38,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond39,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            Constants.terms_cond40,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond41,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            Constants.terms_cond42,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            Constants.terms_cond43,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
