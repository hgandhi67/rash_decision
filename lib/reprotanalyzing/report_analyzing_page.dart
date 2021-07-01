import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rash_decision/base/AppStateModel.dart';
import 'package:rash_decision/base/ads/app_ads.dart';
import 'package:rash_decision/base/appbar/app_bar.dart';
import 'package:rash_decision/base/constants.dart';
import 'package:rash_decision/base/modal_progress_indicator.dart';
import 'package:rash_decision/base/routes.dart';
import 'package:rash_decision/base/theme/art.dart';
import 'package:rash_decision/base/theme/palette.dart';
import 'package:rash_decision/base/theme/styles.dart';
import 'package:rash_decision/home/home_page.dart';
import 'package:rash_decision/widgets/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ReportAnalyzingPage extends StatefulWidget {
  final File imageFile;
  final String fromDependant;

  const ReportAnalyzingPage({Key key, this.imageFile, this.fromDependant})
      : super(key: key);

  @override
  _ReportAnalyzingPageState createState() => _ReportAnalyzingPageState();
}

class _ReportAnalyzingPageState extends State<ReportAnalyzingPage> {
  String dropdownValue = 'Me';
  File imageFile;
  List<String> relationsList = List();
  bool isLoading = false;
  String currentName = '';
  SubscriptionData subscriptionData = SubscriptionData();
  bool willPopScope = true;

  @override
  void dispose() {
//    AppAds.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
//    Future.delayed(Duration(seconds: 3), (){
//      AppAds.init();
//      AppAds.showBanner(
//        anchorType: AnchorType.bottom,
//        childDirected: true,
//        listener: AppAds.bannerListener,
//        size: AdSize.fullBanner,
//      );
//    });
    dropdownValue =
        widget.fromDependant.isNotEmpty ? widget.fromDependant : 'Me';
    imageFile = widget.imageFile;
    setState(() {
      relationsList.add(dropdownValue);
      if (dropdownValue != 'Me') {
        relationsList.add('Me');
      }
    });

    subscriptionData = Provider.of<AppStateModel>(context, listen: false)
        .currentSubscriptionPackage;

    setSharedPref().then((sharedPrefs) {
      Firestore.instance
          .collection('users')
          .document(sharedPrefs.getString(Constants.LOGGED_IN_USER_ID))
          .snapshots()
          .listen((doc) {
        print("HERE I AM");
        if (doc.data != null) {
          setState(() {
            currentName = doc.data['name'];
            print('currentName-->> $currentName');
          });
        }
      });

      _getRelationData(sharedPrefs);
    });
  }

  Future<SharedPreferences> setSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  void _getRelationData(SharedPreferences sharedPreferences) {
    Firestore.instance
        .collection('dependency')
        .document(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
        .collection(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
        .getDocuments()
        .then((docs) {
      for (int i = 0; i < docs.documents.length; i++) {
        print("The docs are : ==> ${docs.documents[i].data}");
        Map<String, dynamic> dataMap = docs.documents[i].data;
        if ('${dataMap['first_name']} ${dataMap['last_name']}' !=
            dropdownValue) {
          relationsList.add('${dataMap['first_name']} ${dataMap['last_name']}');
        }
        if (i == docs.documents.length - 1) {
          setState(() {
            //just refresh
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String newValue =
        Provider.of<AppStateModel>(context).currentDependencyListChanged;
    if (newValue.isNotEmpty) {
      print('The new value is : ===$newValue===');
      relationsList.clear();
      dropdownValue = newValue;
      setState(() {
        relationsList.add(dropdownValue);
        if (dropdownValue != 'Me') {
          relationsList.add('Me');
        }
      });
      setSharedPref().then((sharedPrefs) {
        _getRelationData(sharedPrefs);
      });
      Provider.of<AppStateModel>(context).currentDependencyListChanged = '';
    } else {
      print('The new value 23445 is : ===$newValue===');
    }
    return WillPopScope(
      onWillPop: () => Future.value(willPopScope),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBarWidget.getAppBarWidgetWithLeading(
          appBarTitle: Constants.RASH_ANALYZING,
          context: context,
        ),
        body: ModalProgressHUD(
          isAnimated: true,
          inAsyncCall: isLoading,
          child: Stack(
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
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  width: Constants.screenWidth,
                                  height: Constants.screenHeight * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: Palette.primaryColor,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                    child: Image.file(
                                      imageFile,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                _getWhoseImageLayout(),
                                SizedBox(
                                  height: 10.0,
                                ),
                                _getDependentDropDown(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                MaterialButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  onPressed: () =>
                                      Navigator.of(context).pushNamed(
                                    AppRoutes.ADD_DEPENDENCY,
                                    arguments: {
                                      AppRouteArgKeys.DEPENDENCY_ROUTE_TYPE: 2,
                                      AppRouteArgKeys.DEPENDENCY_IMAGE_FILE:
                                          imageFile,
                                    },
                                  ),
                                  child: Text(
                                    'Add a new dependent here',
                                    style: Styles.buttonTextStyle(
                                      color: Palette.white,
                                    ),
                                  ),
                                  color: Palette.darkButtonColor,
                                  elevation: 2.0,
                                  padding: const EdgeInsets.all(15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: GestureDetector(
                                        child: ButtonWidget(
                                          name: Constants.SUBMIT,
                                          bgColor: Colors.green,
                                        ),
                                        onTap: () {
                                          Provider.of<AppStateModel>(context)
                                              .isInternetConnected()
                                              .then((value) {
                                            if (value) {
                                              submitImageData();
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "Please check your Internet connection.",
                                                      style:
                                                          Styles.workSans500New(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
                                                    ),
//                content: Text("Please check your Internet connection."),
                                                    actions: <Widget>[
                                                      // usually buttons at the bottom of the dialog
                                                      new FlatButton(
                                                        child: new Text("OK"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: Constants.screenWidth * 0.02,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        child: ButtonWidget(
                                          name: Constants.RETAKE,
                                          bgColor: Palette.appBarBgColor,
                                        ),
                                        onTap: () {
                                          Navigator.of(context).popAndPushNamed(
                                              AppRoutes.CAMERA_OVERLAY);
                                        },
                                      ),
                                      flex: 4,
                                    ),
                                  ],
                                ),
                              ],
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
          ),
        ),
      ),
    );
  }

  Widget _getWhoseImageLayout() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            Constants.REPORT_FOR,
            style: Styles.buttonTextStyle(
              color: Palette.textColor,
              size: 16.0,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _showDialog();
          },
          child: CircleAvatar(
            backgroundColor: Palette.primaryColor,
            radius: 15.0,
            child: Text(
              '?',
              style: Styles.buttonTextStyle(
                color: Palette.white,
                size: 16.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getDependentDropDown() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Palette.grey5,
      ),
      child: ButtonTheme(
        alignedDropdown: true,
        child: Container(
          decoration: ShapeDecoration(
            color: Palette.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.0,
                style: BorderStyle.solid,
                color: Palette.borderGrey,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValue,
              isExpanded: true,
              iconSize: 30,
              elevation: 10,
              style: TextStyle(color: Colors.black, fontSize: 16),
              onChanged: (String data) {
                setState(() {
                  dropdownValue = data;
                });
              },
              items: relationsList.isNotEmpty
                  ? relationsList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: Styles.subscriptionTextStyle(
                              fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList()
                  : 'Me',
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding: const EdgeInsets.only(
              top: 15.0,
              right: 15.0,
              left: 15.0,
              bottom: 25.0,
            ),
            width: Constants.screenWidth * 0.8,
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        Constants.DEPENDENTS,
                        style: Styles.subscriptionTextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                          color: Palette.appBarBgColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'When you have added one or more dependents, you are able to keep track of image ownership by selecting \"me\" or a different name',
                        style: Styles.termsAndConditionsContextTextStyle,
                      ),
                    ],
                  ),
                  Positioned(
                    right: 1,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Image.asset(
                        Images.CLOSE_ICON,
                        scale: 1.5,
                        width: 18,
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

  void _startLoading() {
    setState(() {
      willPopScope = false;
      isLoading = true;
    });
  }

  void _stopLoading() {
    setState(() {
      willPopScope = true;
      isLoading = false;
    });
  }

  void submitImageData() async {
    _startLoading();
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        imageFile.path,
        filename: 'disease.png',
      ),
    });

    final response = await Dio()
        .post(Constants.IMAGE_UPLOAD_URL, data: formData)
        .catchError((onError) {
      print("The error is : ${onError.toString()}");
      Toast.show('Error : ${onError.toString()}', context);
      _stopLoading();
      _openErrorPage();
    });

    final resultData = json.decode(response.toString());
    if (resultData != null) {
      print("The response is :===> ${resultData.toString()}");
      if (resultData['validate'] == 'skin') {
        String reviewsTaken = subscriptionData.reviewsTaken != ''
            ? (int.parse(subscriptionData.reviewsTaken) + 1).toString()
            : '1';
        String reviewsLeft = 'unlimited';
        int active = 1;

        if (subscriptionData.activationType != 'unlimited') {
          reviewsLeft =
              (int.parse(subscriptionData.reviewsLeft) - 1).toString();

          if (int.parse(reviewsLeft) == 0) {
            active = 0;
          }
        }

        SubscriptionData newData = SubscriptionData(
          reviewsTaken: reviewsTaken,
          reviewsLeft: reviewsLeft,
          planType: subscriptionData.planType,
          isTrialUtilised: subscriptionData.isTrialUtilised,
          expiryDate: subscriptionData.expiryDate,
          activationType: subscriptionData.activationType,
          activationDate: subscriptionData.activationDate,
          active: active,
        );

        Provider.of<AppStateModel>(context).currentSubscriptionPackage =
            newData;

        setSharedPref().then((sharedPreferences) {
          Firestore.instance
              .collection('account_subscription')
              .document(sharedPreferences.get(Constants.LOGGED_IN_USER_ID))
              .setData({
            'plan_type': newData.planType,
            'reviews_left': newData.reviewsLeft,
            'reviews_taken': newData.reviewsTaken,
            'active': newData.active,
            'expiry_date': newData.expiryDate,
            'activation_date': newData.activationDate,
            'activation_type': newData.activationType,
            'is_trial_utilised': newData.isTrialUtilised,
          }).then((_) {
            print("Validate is skin..");
            if (resultData['Cancer'] == 'NotMelanoma') {
              print("Disease Non Melanoma..");
              _diseaseNonCancerous(resultData);
            } else {
              print("Disease Melanoma..");
              _diseaseCancerous(resultData);
            }
          });
        });
      } else {
        print("Validate is Non-skin..");
        _stopLoading();
        _openErrorPage();
      }
    } else {
      _stopLoading();
      _openErrorPage();
      Toast.show('Error : The api response is null', context);
    }
  }

  void _diseaseNonCancerous(final resultData) {
    for (int i = 0; i < Constants.diseaseList.length; i++) {
      if (resultData['result'].toString().toLowerCase() ==
          Constants.diseaseList[i].name.toLowerCase()) {
        setSharedPref().then((sharedPreferences) {
          String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
          StorageReference ref = FirebaseStorage.instance
              .ref()
              .child(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
              .child('$dateTime.png');
          StorageUploadTask uploadTask = ref.putFile(imageFile);
          uploadTask.onComplete.then((value) {
            value.ref.getDownloadURL().then((url) {
              Firestore.instance
                  .collection('disease')
                  .document(
                      sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
                  .collection(
                      sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
                  .document(dateTime)
                  .setData({
                'id': Constants.diseaseList[i].id,
                'date_time': dateTime,
                'image_url': url,
                'dependent': dropdownValue ?? '',
                'image_path': imageFile != null ? imageFile.path : '',
                'active': true,
                'is_opened': false,
                'cancer': 'NotMelanoma',
                'diseasesName': resultData['result'],
              }).then((_) {
                _stopLoading();
                HomePage.list.add(HistoryData(
                    timeStamp: dateTime,
                    imageUrl: url,
                    dependentName: dropdownValue ?? '',
                    diseases: Constants.diseaseList[i],
                    active: true));
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.SUCCESS_RESULT,
                  arguments: {
                    AppRouteArgKeys.DISEASE_IMAGE_URL: url,
                    AppRouteArgKeys.DISEASE: Constants.diseaseList[i],
                    AppRouteArgKeys.DEPENDENT_NAME:
                        dropdownValue == 'Me' ? currentName : dropdownValue,
                    AppRouteArgKeys.REPORT_RASH_IMAGE_PATH: imageFile.path,
                    AppRouteArgKeys.REPORT_RASH_REPORT_NAME: dateTime,
                  },
                );
              }).catchError((onError) {
                _stopLoading();
                Toast.show('Error : ${onError.toString()}', context);
                _openErrorPage();
              });
            }).catchError((onError) {
              _stopLoading();
              print("Error with getting url :=> ${onError.toString()}");
              Toast.show('Error : ${onError.toString()}', context);
              _openErrorPage();
            });
          }).catchError((onError) {
            _stopLoading();
            print("Error with completing :=> ${onError.toString()}");
            Toast.show('Error : ${onError.toString()}', context);
            _openErrorPage();
          });
        });
        break;
      }
    }
  }

  void _diseaseCancerous(final resultData) {
    for (int i = 0; i < Constants.diseaseList.length; i++) {
      if ('Melanoma'.toLowerCase() ==
          Constants.diseaseList[i].name.toLowerCase()) {
        setSharedPref().then((sharedPreferences) {
          String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
          StorageReference ref = FirebaseStorage.instance
              .ref()
              .child(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
              .child('$dateTime.png');
          StorageUploadTask uploadTask = ref.putFile(imageFile);
          uploadTask.onComplete.then((value) {
            value.ref.getDownloadURL().then((url) {
              Firestore.instance
                  .collection('disease')
                  .document(
                      sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
                  .collection(
                      sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
                  .document(dateTime)
                  .setData({
                'id': Constants.diseaseList[i].id,
                'date_time': dateTime,
                'image_url': url,
                'dependent': dropdownValue ?? '',
                'image_path': imageFile != null ? imageFile.path : '',
                'active': true,
                'is_opened': false,
                'cancer': 'Melanoma',
                'diseasesName': 'Melanoma',
              }).then((_) {
                _stopLoading();
                HomePage.list.add(HistoryData(
                    timeStamp: dateTime,
                    imageUrl: url,
                    dependentName: dropdownValue ?? '',
                    diseases: Constants.diseaseList[i],
                    active: true));
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.REPORT_ANALYSIS,
                  arguments: {
                    AppRouteArgKeys.DISEASE_IMAGE_URL: url,
                    AppRouteArgKeys.DISEASE: Constants.diseaseList[i],
                    AppRouteArgKeys.DEPENDENT_NAME:
                        dropdownValue == 'Me' ? currentName : dropdownValue,
                    AppRouteArgKeys.REPORT_RASH_IMAGE_PATH: imageFile.path,
                    AppRouteArgKeys.REPORT_RASH_CANCER: 'Melanoma',
                  },
                );
              }).catchError((onError) {
                _stopLoading();
                Toast.show('Error : ${onError.toString()}', context);
                _openErrorPage();
              });
            }).catchError((onError) {
              _stopLoading();
              print("Error with getting url :=> ${onError.toString()}");
              Toast.show('Error : ${onError.toString()}', context);
              _openErrorPage();
            });
          }).catchError((onError) {
            _stopLoading();
            print("Error with completing :=> ${onError.toString()}");
            Toast.show('Error : ${onError.toString()}', context);
            _openErrorPage();
          });
        });
        break;
      }
    }
  }

  void _openErrorPage() {
    Navigator.of(context)
        .pushReplacementNamed(AppRoutes.ERROR_PAGE, arguments: {
      AppRouteArgKeys.REPORT_ANALYZING_IMAGE: imageFile,
    });
  }
}
