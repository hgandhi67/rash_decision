import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:rash_decision/base/ads/app_ads.dart';
import 'package:rash_decision/base/appbar/app_bar.dart';
import 'package:rash_decision/base/theme/palette.dart';

class LegalInformation extends StatefulWidget {
  final String pageTitle;
  final Widget pageData;

  const LegalInformation({
    Key key,
    @required this.pageTitle,
    @required this.pageData,
  }) : super(key: key);

  @override
  _LegalInformationPageState createState() => _LegalInformationPageState();
}

class _LegalInformationPageState extends State<LegalInformation> {
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
//
//  @override
//  void dispose() {
//    AppAds.dispose();
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.getAppBarWidgetWithLeading(
        context: context,
        appBarTitle: widget.pageTitle,
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
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(
                      bottom: 25.0,
                      left: 15.0,
                      right: 15.0,
                      top: 20.0,
                    ),
                    child: widget.pageData,
                  ),
                ),
              ),
              const SizedBox(
                height: 60.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
