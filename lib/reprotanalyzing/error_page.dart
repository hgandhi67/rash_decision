import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rash_decision/base/appbar/app_bar.dart';
import 'package:rash_decision/base/constants.dart';
import 'package:rash_decision/base/routes.dart';
import 'package:rash_decision/base/theme/palette.dart';
import 'package:rash_decision/base/theme/styles.dart';
import 'package:rash_decision/widgets/button_widget.dart';

class ErrorPage extends StatefulWidget {
  final File imageFile;

  const ErrorPage({Key key, this.imageFile}) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
//  @override
//  void dispose() {
//    AppAds.dispose();
//    super.dispose();
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    Future.delayed(Duration(seconds: 2), (){
//      AppAds.init();
//      AppAds.showBanner(
//        anchorType: AnchorType.bottom,
//        childDirected: true,
//        listener: AppAds.bannerListener,
//        size: AdSize.fullBanner,
//      );
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBarWidget.getAppBarWidgetWithLeading(
        appBarTitle: 'Error',
        onTap: () {
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.REPORT_ANALYZING,
            arguments: {
              AppRouteArgKeys.REPORT_ANALYZING_IMAGE: widget.imageFile,
              AppRouteArgKeys.IS_FROM_DEPENDENT: 'Me',
            },
          );
        },
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
                  child: Card(
                    elevation: 2.0,
                    margin: EdgeInsets.all(12.0),
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Image.asset(
                            'images/image_error.png',
                            height: 100,
                            width: 100,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          Text(
                            Constants.error_page_text1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'WorkSans',
                              fontSize: 21,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015,
                          ),
                          Text(
                            Constants.error_page_text2,
                            textAlign: TextAlign.center,
                            style: Styles.termsAndConditionsContextTextStyle,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Text(
                            Constants.error_page_text3,
                            textAlign: TextAlign.center,
                            style: Styles.termsAndConditionsContextTextStyle,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    child: ButtonWidget(
                                      name: Constants.RETAKE,
                                      bgColor: Palette.appBarBgColor,
                                    ),
                                    onTap: () {
                                      //camera
                                      Navigator.of(context).popAndPushNamed(
                                          AppRoutes.CAMERA_OVERLAY);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    child: ButtonWidget(
                                      name: Constants.CANCEL,
                                      bgColor: Palette.lightRedColor,
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
                            height: MediaQuery.of(context).size.height * 0.04,
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
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
        ],
      ),
    );
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
