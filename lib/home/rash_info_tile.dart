import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rash_decision/base/AppStateModel.dart';
import 'package:rash_decision/base/constants.dart';
import 'package:rash_decision/base/routes.dart';
import 'package:rash_decision/base/theme/palette.dart';
import 'package:rash_decision/base/theme/styles.dart';
import 'package:rash_decision/model/disease_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class RashInfoTile extends StatelessWidget {
  final String dateTime;
  final String imageUrl;
  final String rashName;
  final Diseases diseases;
  final String dependentName;
  final String imagePath;
  final bool isOpened;
  final String cancer;
  final String diseasesName;

  const RashInfoTile({
    Key key,
    this.dateTime,
    this.imageUrl,
    this.rashName,
    this.diseases,
    this.dependentName,
    this.imagePath,
    this.isOpened: true,
    this.cancer,
    this.diseasesName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    String name="";
//    if(dependentName=='Me') {
//      setSharedPref().then((pref) {
//        name=  pref.getString(Constants.USER_FULLNAME);
//        print('data me name: ${name}');
//      });
//    }
    final f = new DateFormat('MM/dd/yyyy hh:mm:ss');
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: 12.0,
            right: 8.0,
            left: 8.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _rashImage(),
              const SizedBox(
                width: 10.0,
              ),
              _rashInfo(context),
              Text(
                f.format(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(dateTime),
                    isUtc: false)),
                style: Styles.rashTileBoldSmallTextStyle,
              ),
            ],
          ),
        ),
        _buttonLayout(context: context),
        SizedBox(
          height: 15.0,
        ),
        Divider(
          color: Colors.grey[300],
          indent: 8.0,
          endIndent: 8.0,
          thickness: 1.0,
          height: 1,
        ),
      ],
    );
  }

  Widget _rashImage() {
    return Container(
      height: Constants.screenWidth * 0.2,
      width: Constants.screenWidth * 0.2,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5.0),
        image: DecorationImage(
          // here there will be a change with cache image provider instead of the demo asset.
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _rashInfo(BuildContext context) {
//    print("The cancer is : $name");
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                dependentName,
                style: Styles.subscriptionTextStyle(
                    fontWeight: FontWeight.w600, fontSize: 18.0),
              ),
              cancer == null ||
                      cancer.isEmpty == true ||
                      cancer == 'NotMelanoma'
                  ? Text(
                      'Non-Cancerous',
                      style: Styles.buttonTextStyle(
                        color: Palette.buttonGreen,
                        size: 16,
                      ),
                    )
                  : Text(
                      'Cancerous',
                      style: Styles.buttonTextStyle(
                        color: Palette.redColor,
                        size: 16,
                      ),
                    ),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Disease likelihood',
                style: Styles.rashTileSmallTextStyle,
              ),
              cancer == 'NotMelanoma'
                  ? !isOpened
                      ? Text(
                          'Unknown',
                          style: Styles.buttonTextStyle(
                            color: Palette.appBarBgColor,
                          ),
                        )
                      : Text(
                          diseasesName != null ? diseasesName :diseases.name,
                          style: Styles.buttonTextStyle(
                            color: Color(int.parse(diseases.color)),
                          ),
                        )
                  : Text(
                      diseasesName != null ? diseasesName : diseases.name,
                      style: Styles.buttonTextStyle(
                        color: Color(int.parse(diseases.color)),
                      ),
                    )
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
        ],
      ),
    );
  }

  Widget _buttonLayout({BuildContext context}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child:  cancer == 'NotMelanoma'?isOpened
                ? _buttonWidget(
                    text: 'View Report',
                    textColor: Palette.white,
                    onTap: () {
                      Constants.IS_BACK=true;
                      Navigator.of(context).pushNamed(
                        AppRoutes.REPORT_ANALYSIS,
                        arguments: {
                          AppRouteArgKeys.DISEASE_IMAGE_URL: imageUrl,
                          AppRouteArgKeys.DISEASE: diseases,
                          AppRouteArgKeys.DEPENDENT_NAME: dependentName,
                          AppRouteArgKeys.REPORT_RASH_IMAGE_PATH: imagePath,
                          AppRouteArgKeys.REPORT_RASH_CANCER: cancer,
                        },
                      );
                    },
                    backgroundColor: Palette.appBarBgColor,
                  )
                : _buttonWidget(
                    text: 'Continue',
                    textColor: Palette.white,
                    onTap: () {
                      _showDialog(context);
                    },
                    backgroundColor: Palette.buttonGreen,
                  )
      : _buttonWidget(
              text: 'View Report',
              textColor: Palette.white,
              onTap: () {
                Constants.IS_BACK=true;
                Navigator.of(context).pushNamed(
                  AppRoutes.REPORT_ANALYSIS,
                  arguments: {
                    AppRouteArgKeys.DISEASE_IMAGE_URL: imageUrl,
                    AppRouteArgKeys.DISEASE: diseases,
                    AppRouteArgKeys.DEPENDENT_NAME: dependentName,
                    AppRouteArgKeys.REPORT_RASH_IMAGE_PATH: imagePath,
                    AppRouteArgKeys.REPORT_RASH_CANCER: cancer,
                  },
                );
              },
              backgroundColor: Palette.appBarBgColor,
            )
          ),
          const SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: _buttonWidget(
              text: 'Delete Report',
              textColor: Palette.white,
              onTap: () {
                _showDeleteDialog(context);
              },
              backgroundColor: Palette.redColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<SharedPreferences> setSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  void _deleteDiseaseData(String dateTime, BuildContext context, int id) async {
    Constants.IS_DELETED = true;
    setSharedPref().then((sharedPreferences) {
      Firestore.instance
          .collection('disease')
          .document(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
          .collection(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
          .document(dateTime)
          .updateData({
        'active': false,
      }).then((_) {
        // print('deleteCurrentEntry 111111111 ${dateTime}' );
        Provider.of<AppStateModel>(context).deleteCurrentEntry = dateTime;
        Navigator.of(context).pop();
      });
    });
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: const EdgeInsets.only(
              top: 15.0,
              right: 8.0,
              left: 8.0,
              bottom: 12.0,
            ),
            width: Constants.screenWidth * 0.8,
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Are you sure you want to continue?',
                    textAlign: TextAlign.center,
                    style: Styles.subscriptionTextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            setSharedPref().then((sharedPreferences) {
                              Firestore.instance
                                  .collection('disease')
                                  .document(sharedPreferences
                                      .getString(Constants.LOGGED_IN_USER_ID))
                                  .collection(sharedPreferences
                                      .getString(Constants.LOGGED_IN_USER_ID))
                                  .document(dateTime)
                                  .updateData({
                                'is_opened': true,
                              }).then((_) {
                                Provider.of<AppStateModel>(context).setHistoryEvent(true);
                                Navigator.of(context).popAndPushNamed(
                                  AppRoutes.REPORT_ANALYSIS,
                                  arguments: {
                                    AppRouteArgKeys.DISEASE_IMAGE_URL: imageUrl,
                                    AppRouteArgKeys.DISEASE: diseases,
                                    AppRouteArgKeys.DEPENDENT_NAME:
                                        dependentName,
                                    AppRouteArgKeys.REPORT_RASH_IMAGE_PATH:
                                        imagePath,
                                    AppRouteArgKeys.REPORT_RASH_CANCER: cancer,
                                  },
                                );
                              }).catchError((onError) {
                                print("The error is : ${onError.toString()}");
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Toast.show(
                                      'Something went wrong, please try again.',
                                      context);
                                });
                              });
                            });
                          },
                          child: Text(
                            'Yes',
                            style: Styles.subscriptionTextStyle(
                              color: Palette.white,
                              fontSize: 16.0,
                            ),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          color: Palette.appBarBgColor,
                        ),
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Expanded(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: Styles.subscriptionTextStyle(
                              color: Palette.white,
                              fontSize: 16.0,
                            ),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          color: Palette.redColor,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: const EdgeInsets.only(
              top: 15.0,
              right: 8.0,
              left: 8.0,
              bottom: 12.0,
            ),
            width: Constants.screenWidth * 0.8,
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Do you really want to delete this report?',
                    textAlign: TextAlign.center,
                    style: Styles.subscriptionTextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            _deleteDiseaseData(dateTime, context, diseases.id);
                          },
                          child: Text(
                            'Yes',
                            style: Styles.subscriptionTextStyle(
                              color: Palette.white,
                              fontSize: 16.0,
                            ),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          color: Palette.appBarBgColor,
                        ),
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Expanded(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: Styles.subscriptionTextStyle(
                              color: Palette.white,
                              fontSize: 16.0,
                            ),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          color: Palette.redColor,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buttonWidget({
    Color backgroundColor,
    Color textColor,
    String text,
    onTap,
  }) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: Styles.smallButtonTextStyle(
          color: textColor,
        ),
      ),
      padding: const EdgeInsets.all(15.0),
      color: backgroundColor,
    );
  }
}
