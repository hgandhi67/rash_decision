import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:android_intent/android_intent.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:rash_decision/base/constants.dart';
import 'package:rash_decision/base/theme/art.dart';
import 'package:rash_decision/base/theme/palette.dart';
import 'package:rash_decision/base/theme/styles.dart';
import 'package:rash_decision/model/GetPhoneNumberModel.dart';
import 'package:rash_decision/model/disease_model.dart';
import 'package:rash_decision/model/placeApiModel.dart';
import 'package:rash_decision/reportandanalysis/report_analysis_page.dart';
import 'package:toast/toast.dart';

class AnalysisWidget extends StatefulWidget {
  final Diseases diseases;
  final String cancer;

  List<Result> hospitalList;
  List<Result> medicalList;

  AnalysisWidget(
      {Key key,
      @required this.diseases,
      @required this.hospitalList,
      @required this.cancer,
      @required this.medicalList})
      : super(key: key);

  @override
  _AnalysisWidgetState createState() => _AnalysisWidgetState();
}

class _AnalysisWidgetState extends State<AnalysisWidget> {
  List<String> litems = ["1", "2", "Third", "4"];

  static const double HEIGHT = 55.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _showCommonSymptomsDialog();
            },
            child: Card(
              margin: EdgeInsets.only(
                left: 2,
                right: 4,
              ),
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
//                        bottomLeft: Radius.circular(15),
                      ),
                      color: Palette.commonSymptomsColor,
                    ),
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        'images/tab_symptoms_large.png',
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
//                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10.0, bottom: 10.0),
                        child: Text(
                          "Common Symptoms",
                          style: Styles.subscriptionTextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showCommonCausesDialog();
            },
            child: Card(
              margin: EdgeInsets.only(
                left: 2,
                right: 4,
                top: HEIGHT,
              ),
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
//                        bottomLeft: Radius.circular(15),
                      ),
                      color: Palette.commonCausesColor,
                    ),
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        'images/tab_causes_large.png',
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
//                          bottomRight: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          color: Colors.white),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10.0, bottom: 10.0),
                        child: Text(
                          "Common Causes",
                          style: Styles.subscriptionTextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showActionsDialog();
            },
            child: Card(
              margin: EdgeInsets.only(
                left: 2,
                right: 4,
                top: HEIGHT * 2,
              ),
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
//                        bottomLeft: Radius.circular(15),
                      ),
                      color: Palette.actionsColor,
                    ),
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        'images/tab_selfcare_lg.png',
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
//                          bottomRight: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          color: Colors.white),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10.0, bottom: 10.0),
                        child: Text(
                          "Actions/Self-Care",
                          style: Styles.subscriptionTextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.cancer == 'NotMelanoma',
            child: GestureDetector(
              onTap: () {
                _showRemediesDialog();
              },
              child: Card(
                margin: EdgeInsets.only(
                  left: 2,
                  right: 4,
                  top: HEIGHT * 3,
                ),
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
//                        bottomLeft: Radius.circular(15),
                        ),
                        color: Palette.remediesColor,
                      ),
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(
                          'images/tab_remedies_large.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
//                          bottomRight: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            color: Colors.white),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 10.0),
                          child: Text(
                            "Remedies",
                            style: Styles.subscriptionTextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.cancer == 'NotMelanoma',
            child: GestureDetector(
              onTap: () {
                if (widget.medicalList?.isNotEmpty == true) {
                  _showPharmaCentersDialog();
                } else {
                  fetchLocation();
                  Toast.show('We are fetching data', context, duration: 2);
                }
              },
              child: Card(
                margin: EdgeInsets.only(
                  left: 2,
                  right: 4,
                  top: HEIGHT * 4,
                ),
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
//                        bottomLeft: Radius.circular(15),
                        ),
                        color: Palette.pharmaColor,
                      ),
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(
                          'images/tab_medi_pharma_large.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
//                          bottomRight: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            color: Colors.white),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 10.0),
                          child: Text(
                            "Pharmacy Near You",
                            style: Styles.subscriptionTextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.hospitalList?.isNotEmpty == true) {
                _showMedicalCentersDialog();
              } else {
                fetchLocation();
                Toast.show('We are fetching data', context, duration: 2);
              }
            },
            child: Card(
              margin: EdgeInsets.only(
                left: 2,
                right: 4,
                top: widget.cancer == 'NotMelanoma' ? HEIGHT * 5 : HEIGHT * 3,
              ),
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
//                        bottomLeft: Radius.circular(15),
                      ),
                      color: Palette.medicalColor,
                    ),
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        'images/tab_medi_center_large.png',
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
//                          bottomRight: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          color: Colors.white),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10.0, bottom: 10.0),
                        child: Text(
                          "Medical Center Near You",
                          style: Styles.subscriptionTextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showMelanomaDialog();
            },
            child: Card(
              margin: EdgeInsets.only(
                left: 2,
                right: 4,
                top: widget.cancer == 'NotMelanoma' ? HEIGHT * 6 : HEIGHT * 4,
              ),
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      color: Palette.melanomaColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        'images/tab_allergic_large.png',
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "${widget.diseases.name} Images",
                          style: Styles.subscriptionTextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCommonSymptomsDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Constants.screenWidth * 0.4,
                    decoration: BoxDecoration(
                      color: Palette.commonSymptomsColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          left: 1,
                          top: 1,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              top: 15.0,
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Image.asset(
                                Images.CLOSE_ICON,
                                scale: 1.3,
                                width: 18,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'images/tab_symptoms_large.png',
                              height: MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.15,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "Common Symptoms",
                              style: Styles.subscriptionTextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Palette.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 12.0, top: 12.0, bottom: 16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.diseases.symptoms.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RichText(
                          text: TextSpan(
                            text: '',
                            children: [
                              TextSpan(
                                text: '⦿	 ',
                                style: Styles.subscriptionTextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff5E686B),
                                ),
                              ),
                              TextSpan(
                                text: widget.diseases.symptoms[index],
                                style: Styles.subscriptionTextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCommonCausesDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Constants.screenWidth * 0.4,
                    decoration: BoxDecoration(
                      color: Palette.commonCausesColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          left: 1,
                          top: 1,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              top: 15.0,
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Image.asset(
                                Images.CLOSE_ICON,
                                scale: 1.3,
                                width: 18,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'images/tab_causes_large.png',
                              height: MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.15,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "Common Causes",
                              style: Styles.subscriptionTextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Palette.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 12.0, top: 12.0, bottom: 16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.diseases.causes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RichText(
                          text: TextSpan(
                            text: '',
                            children: [
                              TextSpan(
                                text: '⦿	 ',
                                style: Styles.subscriptionTextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff5E686B),
                                ),
                              ),
                              TextSpan(
                                text: widget.diseases.causes[index],
                                style: Styles.subscriptionTextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showActionsDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Constants.screenWidth * 0.4,
                    decoration: BoxDecoration(
                      color: Palette.actionsColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          left: 1,
                          top: 1,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              top: 15.0,
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Image.asset(
                                Images.CLOSE_ICON,
                                scale: 1.3,
                                width: 18,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'images/tab_selfcare_lg.png',
                              height: MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.15,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "Actions/Self-Care",
                              style: Styles.subscriptionTextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Palette.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 12.0, top: 12.0, bottom: 16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.diseases.actions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RichText(
                          text: TextSpan(
                            text: '',
                            children: [
                              TextSpan(
                                text: '⦿	 ',
                                style: Styles.subscriptionTextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff5E686B),
                                ),
                              ),
                              TextSpan(
                                text: widget.diseases.actions[index],
                                style: Styles.subscriptionTextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMedicalCentersDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Constants.screenWidth * 0.4,
                    decoration: BoxDecoration(
                      color: Palette.medicalColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          left: 1,
                          top: 1,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              top: 15.0,
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Image.asset(
                                Images.CLOSE_ICON,
                                scale: 1.3,
                                width: 18,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'images/tab_medi_center_large.png',
                              height: MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.15,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "Medical Center Near You",
                              style: Styles.subscriptionTextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Palette.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
                    child: ListView.builder(
                      itemCount: widget.hospitalList.length > 5
                          ? 5
                          : widget.hospitalList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return MedicalItem(
                          name: widget.hospitalList[i].name,
                          distance: (calculateDistance(
                                      Constants.latitude,
                                      Constants.longitude,
                                      widget.hospitalList[i].geometry.location
                                          .lat,
                                      widget.hospitalList[i].geometry.location
                                          .lng))
                                  .toStringAsFixed(2) +
                              ' Miles away',
                          lat: widget.hospitalList[i].geometry.location.lat,
                          log: widget.hospitalList[i].geometry.location.lng,
                          address: widget.hospitalList[i].vicinity,
                          call: widget.hospitalList[i].phone_number,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRemediesDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Constants.screenWidth * 0.4,
                    decoration: BoxDecoration(
                      color: Palette.remediesColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          left: 1,
                          top: 1,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              top: 15.0,
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Image.asset(
                                Images.CLOSE_ICON,
                                scale: 1.3,
                                width: 18,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'images/tab_remedies_large.png',
                              height: MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.15,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "Remedies",
                              style: Styles.subscriptionTextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Palette.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 12.0, top: 12.0, bottom: 16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.diseases.remedies_list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text: '',
                                children: [
                                  TextSpan(
                                    text: '⦿	 ',
                                    style: Styles.subscriptionTextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff5E686B),
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget
                                        .diseases.remedies_list[index].title,
                                    style: Styles.subscriptionTextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: widget.diseases.remedies_list[index]
                                      .description !=
                                  null,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  widget.diseases.remedies_list[index]
                                              .description !=
                                          null
                                      ? widget.diseases.remedies_list[index]
                                          .description
                                      : "",
                                  style: Styles.subscriptionTextStyle(
                                    color: Colors.black26,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.diseases.remedies_list[index]
                                    .sub_list.length,
                                itemBuilder:
                                    (BuildContext context, int indexNew) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          text: '',
                                          children: [
                                            TextSpan(
                                              text: '	•	 ',
                                              style:
                                                  Styles.subscriptionTextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff5E686B),
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget
                                                  .diseases
                                                  .remedies_list[index]
                                                  .sub_list[indexNew],
                                              style:
                                                  Styles.subscriptionTextStyle(
                                                color: Colors.black45,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPharmaCentersDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Constants.screenWidth * 0.4,
                    decoration: BoxDecoration(
                      color: Palette.pharmaColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          left: 1,
                          top: 1,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              top: 15.0,
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Image.asset(
                                Images.CLOSE_ICON,
                                scale: 1.3,
                                width: 18,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'images/tab_medi_pharma_large.png',
                              height: MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.15,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "Pharmacy Near You",
                              style: Styles.subscriptionTextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Palette.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
                    child: ListView.builder(
                      itemCount: widget.medicalList.length > 5
                          ? 5
                          : widget.medicalList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return MedicalItem(
                          name: widget.medicalList[i].name,
                          distance: (calculateDistance(
                                      Constants.latitude,
                                      Constants.longitude,
                                      widget
                                          .medicalList[i].geometry.location.lat,
                                      widget.medicalList[i].geometry.location
                                          .lng))
                                  .toStringAsFixed(2) +
                              ' Miles away',
                          lat: widget.medicalList[i].geometry.location.lat,
                          log: widget.medicalList[i].geometry.location.lng,
                          address: widget.medicalList[i].vicinity,
                          call: widget.medicalList[i].phone_number,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMelanomaDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Constants.screenWidth * 0.4,
                    decoration: BoxDecoration(
                      color: Palette.melanomaColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          left: 1,
                          top: 1,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 15.0,
                              top: 15.0,
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Image.asset(
                                Images.CLOSE_ICON,
                                scale: 1.3,
                                width: 18,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'images/tab_allergic_large.png',
                              height: MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.15,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              "${widget.diseases.name} Images",
                              style: Styles.subscriptionTextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Palette.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: Constants.screenWidth * 0.4,
                      child: Carousel(
                        autoplay: false,
                        dotBgColor: Colors.transparent,
                        dotColor: Palette.melanomaColor,
                        dotIncreasedColor: Palette.melanomaColor,
                        images: widget.diseases.images.map((image) {
                          return ExactAssetImage(image);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  void fetchLocation() async {
    await LocationPermissions().requestPermissions().then((status) async {
      if (status == PermissionStatus.denied) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          print('Permission has been denied');
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    content: Text(
                      'Please give location permissions from settings to use application functionalities',
                      textAlign: TextAlign.center,
                      style: Styles.workSans500New(
                          color: Colors.black, fontSize: 18),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          print('Permission has been denied okkkkkkkkkk');
                          Navigator.of(context).pop();
                          if (Platform.isAndroid) {
                            checkPermission();
                          } else {
                            LocationPermissions().openAppSettings();
                          }
                        },
                      ),
//                      FlatButton(
//                        child: Text('Cancel'),
//                        onPressed: () {
//                          Navigator.of(context).pop();
//                        },
//                      ),
                    ],
                  ));
          print('Permission has been denied show dialog');
        });
      } else {
        print('latlong--->> request -----granted-------->>>');
        bool isEnabled = await Geolocator().isLocationServiceEnabled();
        if (isEnabled) {
          Position position = await Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          Constants.latitude = position.latitude;
          Constants.longitude = position.longitude;
          print('latlong--->> ${Constants.latitude}');
          getMedical();
          if (widget.cancer == 'NotMelanoma') {
            getPharmacy(widget);
          }
        } else {
//            Toast.show('Please enable GPS and try again.', context);
          Future.delayed(const Duration(milliseconds: 1000), () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => AlertDialog(
                      content: Text(
                        'Please enabled gps from settings to use application functionalities',
                        textAlign: TextAlign.center,
                        style: Styles.workSans500New(
                            color: Colors.black, fontSize: 18),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Ok'),
                          onPressed: () {
                            print('Permission has been denied okkkkkkkkkk');
                            //Navigator.of(context).pop();
                            if (Platform.isAndroid) {
                              openLocationSetting();
                            }
                            Navigator.of(context).pop();
//                    else {
//                      LocationPermissions().openAppSettings();
//                    }
                          },
                        ),
                        FlatButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
          });
        }
      }
    }).catchError((onError) {
      print("The error we got is : ${onError.toString()}");
    });
  }

  void getMedical() async {
    try {
      Response response =
          await Dio().get(Constants.PLACE_SEARCH_API, queryParameters: {
        "key": Constants.PLACE_API_KEY,
        "fields": "name,rating",
        "type": "hospital",
        "keyword": widget.cancer == 'NotMelanoma' ? '' : 'Cancer',
        "location": Constants.latitude.toString() +
            "," +
            Constants.longitude.toString(),
        "rankby": "distance",
//        "radius": "500",
      });

      final jsonData = json.decode(response.toString());
      var response1 = PlaceApiModel.fromJson(jsonData);
      if (response1.results.length > 0) {
        int totalSize;
        if (response1.results.length > 5) {
          totalSize = 5;
        } else {
          totalSize = response1.results.length;
        }

        for (int i = 0; i < totalSize; i++) {
          print('phone num id:--->>> ${response1.results[i].place_id}');
          Response responsePhone =
              await Dio().get(Constants.PLACE_GET_PHONE_API, queryParameters: {
            "key": Constants.PLACE_API_KEY,
            "fields": "name,rating,formatted_phone_number",
            "place_id": response1.results[i].place_id,
          }).catchError((onError) {
            print("The error in fetching phone : ${onError.toString()}");
          });
          final jsonData = json.decode(responsePhone.toString());
          var responseNew = GetPhoneNumberModel.fromJson(jsonData);
          print("The added phone number is : ${responseNew.result.formatted_phone_number}");
          response1.results[i].phone_number =
              responseNew.result.formatted_phone_number;
        }

        setState(() {
          print("HELLO WORLD");
          widget.hospitalList = response1.results;
        });
      }
    } catch (e) {
      print("response:->>>> 0011111$e");
      print(e);
    }
  }

  void getPharmacy(AnalysisWidget widget) async {
    try {
      Response response =
          await Dio().get(Constants.PLACE_SEARCH_API, queryParameters: {
        "key": Constants.PLACE_API_KEY,
        "fields": "name,rating",
        "type": "pharmacy",
        "location": Constants.latitude.toString() +
            "," +
            Constants.longitude.toString(),
        "rankby": "distance",
//        "radius": "500",
      });

      final jsonData = json.decode(response.toString());
      var response1 = PlaceApiModel.fromJson(jsonData);
      if (response1.results.length > 0) {
        int totalSize;
        if (response1.results.length > 5) {
          totalSize = 5;
        } else {
          totalSize = response1.results.length;
        }

        for (int i = 0; i < totalSize; i++) {
          print('phone num id:--->>> ${response1.results[i].place_id}');
          Response responsePhone =
              await Dio().get(Constants.PLACE_GET_PHONE_API, queryParameters: {
            "key": Constants.PLACE_API_KEY,
            "fields": "name,rating,formatted_phone_number",
            "place_id": response1.results[i].place_id,
          });
          final jsonData = json.decode(responsePhone.toString());
          var responseNew = GetPhoneNumberModel.fromJson(jsonData);
          response1.results[i].phone_number =
              responseNew.result.formatted_phone_number;
        }

        setState(() {
          widget.medicalList = response1.results;
        });
      }
    } catch (e) {
      print("response:->>>> 0011111$e");
      print(e);
    }
  }

  void checkPermission() async {
    PermissionStatus permission =
        await LocationPermissions().checkPermissionStatus();
    print("Erorrhakjha ===> $permission");
    if (permission == PermissionStatus.granted) {
      bool isEnabled = await Geolocator().isLocationServiceEnabled();
      if (isEnabled) {
        Position position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        Constants.latitude = position.latitude;
        Constants.longitude = position.longitude;
        print('latlong--->> ${Constants.latitude}');
        getMedical();
        if (widget.cancer == 'NotMelanoma') {
          getPharmacy(widget);
        }
      } else {
        Future.delayed(const Duration(milliseconds: 1000), () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => AlertDialog(
                    content: Text(
                      'Please enabled gps from settings to use application functionalities',
                      textAlign: TextAlign.center,
                      style: Styles.workSans500New(
                          color: Colors.black, fontSize: 18),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          print('Permission has been denied okkkkkkkkkk');
                          //Navigator.of(context).pop();
                          if (Platform.isAndroid) {
                            openLocationSetting();
                          }
                          Navigator.of(context).pop();
//                    else {
//                      LocationPermissions().openAppSettings();
//                    }
                        },
                      ),
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));
        });

//        Toast.show('Please enable GPS and try again.', context);
      }
    } else {
      await LocationPermissions().requestPermissions().then((status) async {
        print('latlong--->> request ------------->>>$status');
        if (status == PermissionStatus.denied) {
          print('latlong--->> request ----------denied--->>>');
          Future.delayed(const Duration(milliseconds: 1000), () {
            print('Permission has been denied');
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      content: Text(
                        'Please give location permissions from settings to use application functionalities',
                        textAlign: TextAlign.center,
                        style: Styles.workSans500New(
                            color: Colors.black, fontSize: 18),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Ok'),
                          onPressed: () {
                            print('Permission has been denied okkkkkkkkkk');
                            Navigator.of(context).pop();
                            if (Platform.isAndroid) {
                              checkPermission();
                            } else {
                              LocationPermissions().openAppSettings();
                            }
                          },
                        ),
//                      FlatButton(
//                        child: Text('Cancel'),
//                        onPressed: () {
//                          Navigator.of(context).pop();
//                        },
//                      ),
                      ],
                    ));
            print('Permission has been denied show dialog');
          });
        } else if (status == PermissionStatus.granted) {
          print('latlong--->> request -----granted-------->>>');
          bool isEnabled = await Geolocator().isLocationServiceEnabled();
          if (isEnabled) {
            Position position = await Geolocator()
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            Constants.latitude = position.latitude;
            Constants.longitude = position.longitude;
            print('latlong--->> ${Constants.latitude}');
            getMedical();
            if (widget.cancer == 'NotMelanoma') {
              getPharmacy(widget);
            }
          } else {
//            Toast.show('Please enable GPS and try again.', context);
            Future.delayed(const Duration(milliseconds: 1000), () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => AlertDialog(
                        content: Text(
                          'Please enabled gps from settings to use application functionalities',
                          textAlign: TextAlign.center,
                          style: Styles.workSans500New(
                              color: Colors.black, fontSize: 18),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                              print('Permission has been denied okkkkkkkkkk');
                              //Navigator.of(context).pop();
                              if (Platform.isAndroid) {
                                openLocationSetting();
                              }
                              Navigator.of(context).pop();
//                    else {
//                      LocationPermissions().openAppSettings();
//                    }
                            },
                          ),
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
            });
          }
        }
      }).catchError((onError) {
        print("The error we got is : ${onError.toString()}");
      });
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    print('calculateDistance   ${lat1} &&&  ${lon1} &&& ${lat2} &&& ${lon2}');
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
