import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:rash_decision/base/ads/app_ads.dart';
import 'package:rash_decision/base/appbar/app_bar.dart';
import 'package:rash_decision/base/constants.dart';
import 'package:rash_decision/base/theme/art.dart';
import 'package:rash_decision/base/theme/palette.dart';
import 'package:rash_decision/base/theme/styles.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

//  @override
//  void dispose() {
//    AppAds.dispose();
//    super.dispose();
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    AppAds.init();
//    AppAds.showBanner(
//      anchorType: AnchorType.bottom,
//      childDirected: true,
//      listener: AppAds.bannerListener,
//      size: AdSize.fullBanner,
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.getAppBarWidgetWithLeading(
        context: context,
        appBarTitle: Constants.AboutUs,
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'images/grayscale_bg.jpg',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: Palette.white,
                    padding: const EdgeInsets.only(
                      bottom: 25.0,
                      left: 15.0,
                      right: 15.0,
                      top: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Constants.APP_NAME,
                          style: Styles.subscriptionTextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: Palette.appBarBgColor,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          Constants.ABOUT_US_DATA,
                          style: Styles.subscriptionTextStyle(
                            color: Palette.homeScreenInfoTextColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Center(
                          child: Column(
                            children: <Widget>[
                              Text.rich(
                                TextSpan(
                                  text: 'Contact email: ',
                                  style: Styles.contactEmailTextStyle,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'info@data245.com',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // can add more TextSpans here...
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Image.asset(
                                Images.DATA_245,
                                fit: BoxFit.cover,
                                height: 40,
                                width: 150,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
