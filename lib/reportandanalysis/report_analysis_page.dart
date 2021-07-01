import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:launch_review/launch_review.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rash_decision/base/ads/app_ads.dart';
import 'package:rash_decision/base/appbar/app_bar.dart';
import 'package:rash_decision/base/constants.dart';
import 'package:rash_decision/base/theme/art.dart';
import 'package:rash_decision/base/theme/palette.dart';
import 'package:rash_decision/base/theme/styles.dart';
import 'package:rash_decision/home/home_page.dart';
import 'package:rash_decision/model/GetPhoneNumberModel.dart';
import 'package:rash_decision/model/disease_model.dart';
import 'package:rash_decision/model/placeApiModel.dart';
import 'package:rash_decision/reportandanalysis/analysis_tiles_widget.dart';
import 'package:rash_decision/widgets/progress_bar.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ReportAnalysisPage extends StatefulWidget {
  final Diseases disease;
  final String imageUrl;
  final String dependentName;
  final String cancer;
  final imagePath;
  String currentEmail = "";
  String sendText = "";
  int riskPer = 0;
  List<Result> hospitalList = List();
  List<Result> medicalList = List();
  bool isFirst = false;

  ReportAnalysisPage({
    Key key,
    this.disease,
    this.hospitalList,
    this.imageUrl,
    this.dependentName,
    @required this.imagePath,
    @required this.cancer,
  }) : super(key: key);

  @override
  _ReportAnalysisPageState createState() => _ReportAnalysisPageState();
}

class _ReportAnalysisPageState extends State<ReportAnalysisPage> {
  @override
  void dispose() {
//    AppAds.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    AppAds.init();
    AppAds.showScreenAds(
      listener: AppAds.screenListener,
      childDirected: true,
    );

//    Future.delayed(Duration(seconds: 2), () {
//      AppAds.showBanner(
//        anchorType: AnchorType.bottom,
//        childDirected: true,
//        listener: AppAds.bannerListener,
//        size: AdSize.fullBanner,
//      );
//    });
  }

  void addData(List<Result> response) {
    setState(() {
      print("set State");
      widget.hospitalList = response;

      print("set medicalList-->> ${widget.hospitalList.length}");
    });
  }

  void addPharmacyData(List<Result> response) {
    setState(() {
      print("set State");
      widget.medicalList = response;

      print("set medicalList-->> ${widget.medicalList.length}");
    });
  }

  void checkPermission(ReportAnalysisPage widget) async {
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
        getMedical(widget);
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
                              checkPermission(widget);
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
            getMedical(widget);
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

  void openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  void getEmail() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    widget.currentEmail = user.email;
  }

  @override
  Widget build(BuildContext context) {
    print("set build${widget.isFirst}");

    if (widget.currentEmail.isEmpty) {
      getEmail();
    }

    if (!widget.isFirst) {
      checkPermission(widget);
      widget.isFirst = true;
    }
    print('widget.disease.riskFactor ${widget.disease.Factor}');
    if (widget.disease.Factor == "High") {
      widget.riskPer = 90;
    } else if (widget.disease.Factor == "Medium") {
      widget.riskPer = 60;
    } else if (widget.disease.Factor == "Low") {
      widget.riskPer = 20;
    }

//   print('check permission-->> ${isPermissionAcpt()}');

// fetchData();
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
          Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Palette.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _getTopLayout(),
                            const SizedBox(
                              height: 8.0,
                            ),
                            _getDescriptionLayout(),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, bottom: 16.0, right: 12.0),
                              child: MaterialButton(
                                onPressed: () {
                                  var reportFor = "";
                                  print(
                                      'click on email share ${widget.dependentName}');
                                  if (widget.dependentName != null) {
                                    if (widget.dependentName == 'Me') {
                                      reportFor = "My Report";
                                    } else {
                                      reportFor =
                                          "${widget.dependentName} Report";
                                    }
                                  }
                                  _launchURL(
                                    "",
                                    reportFor,
                                    widget.imageUrl,
                                    context,
                                  );
                                },
                                color: Palette.appBarBgColor,
                                minWidth: MediaQuery.of(context).size.width,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Share to Email',
                                  style: Styles.buttonTextStyle(
                                    color: Palette.white,
                                    size: 15.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      AnalysisWidget(
                        diseases: widget.disease,
                        hospitalList: widget.hospitalList,
                        cancer: widget.cancer,
                        medicalList: widget.medicalList,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      _getHelpfulLayout(),
                      const SizedBox(
                        height: 15.0,
                      ),
                    ],
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

  Widget _getHelpfulLayout() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Palette.appBarBgColorOpacity,
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Text(
            'Are you finding Rash Decision helpful?',
            style: Styles.subscriptionTextStyle(
              color: Palette.white,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  //google rating page
                  LaunchReview.launch(
                    androidAppId: 'com.rash.decision.app',
                    iOSAppId: 'com.data245.rashdecisionapp',
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                padding: const EdgeInsets.all(5.0),
                color: Palette.white,
                child: Text(
                  'Yes!',
                  style: Styles.subscriptionTextStyle(
                    fontWeight: FontWeight.w500,
                    color: Palette.appBarBgColor,
                  ),
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              MaterialButton(
                onPressed: () {
//                  Navigator.of(context).pushAndRemoveUntil(
//                      MaterialPageRoute<void>(
//                        builder: (BuildContext context) => HomePage(),
//                      ),
//                      (Route<dynamic> route) => false);
                  Navigator.of(context)
                      .popUntil((r) => r.settings.name == 'HomePage');
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(
                    width: 1,
                    color: Colors.white,
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Not Really',
                  style: Styles.subscriptionTextStyle(
                    fontWeight: FontWeight.w500,
                    color: Palette.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getRashImage() {
    return Container(
      width: Constants.screenWidth * 0.28,
      height: Constants.screenWidth * 0.28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Palette.primaryColor),
      ),
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(8.0),
        child: Image.network(
          widget.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _getDiseaseLikelihood() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          Constants.LIKELIHOOD,
          style: Styles.workSans500(color: Colors.grey),
        ),
        Text(
          widget.disease.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Styles.workSans600(
              color: Color(int.parse(widget.disease.color)), fontSize: 16),
        ),
      ],
    );
  }

  Widget _getRiskFactor() {
    return Row(
      children: <Widget>[
        Text(
          Constants.RISK_FACTOR,
          style: Styles.workSans500(color: Colors.grey),
        ),
        SizedBox(
          width: Constants.screenWidth * 0.01,
        ),
        Expanded(
          child: Text(
            widget.disease.Factor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Styles.workSans600(
                color: Color(int.parse(widget.disease.color)), fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _getOtherDetails() {
    print(
        "_getOtherDetails-->>> ${widget.dependentName} && ${widget.riskPer} && ${widget.disease.color}");
    return Expanded(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 0.0, bottom: 0.0, right: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.dependentName,
                style: Styles.workSans600(color: Palette.textColor),
              ),
              const SizedBox(
                height: 8,
              ),
              _getDiseaseLikelihood(),
              const SizedBox(
                height: 8,
              ),
              _getRiskFactor(),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: ProgressBar(
                  animatedDuration: Duration(milliseconds: 1000),
                  progressColor: Color(int.parse(widget.disease.color)),
                  currentValue: widget.riskPer,
                  size: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTopLayout() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0, right: 12.0),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _getRashImage(),
            _getOtherDetails(),
          ],
        ),
      ),
    );
  }

  Widget _getDescriptionLayout() {
    print("_getDescriptionLayout-->>> ${widget.disease.description} ");
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0, right: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Constants.DESCRIPTION,
            style: Styles.workSans500(color: Colors.grey),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            widget.disease.description,
            style: Styles.subscriptionTextStyle(),
          ),
        ],
      ),
    );
  }

  void getMedical(ReportAnalysisPage widget) async {
    print("_getDescriptionLayout-->>> ${widget.cancer} ");
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
          });
          final jsonData = json.decode(responsePhone.toString());
          var responseNew = GetPhoneNumberModel.fromJson(jsonData);
          response1.results[i].phone_number =
              responseNew.result.formatted_phone_number;
        }

        addData(response1.results);
      }
    } catch (e) {
      print("response:->>>> 0011111$e");
      print(e);
    }
  }

  void getPharmacy(ReportAnalysisPage widget) async {
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

        addPharmacyData(response1.results);
      }
    } catch (e) {
      print("response:->>>> 0011111$e");
      print(e);
    }
  }

  _launchURL(String toMailId, String subject, String attachmentUrl,
      BuildContext context) async {
    var data;
    if (Platform.isAndroid) {
      data = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      data = await getApplicationSupportDirectory();
    }
    var firstPath = data.path + "/RashImages";
    print("The click we get.... ==> $attachmentUrl");
    await Directory(firstPath).create(recursive: true);
    var response = await http.get(attachmentUrl).catchError((onError) {
      Toast.show('Error in sharing, please try again later', context);
      print("Error in sharing:=> ${onError.toString()}");
      return;
    });
    File file = File(
        firstPath + '/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg');
    file.writeAsBytesSync(response.bodyBytes);
    final Email email = Email(
      body: getBody(),
      subject: subject,
      recipients: [toMailId],
      attachmentPath: file.path,
      isHTML: false,
    );
    await FlutterEmailSender.send(email).catchError((onError) {
      Toast.show('Error in sharing, please try again later', context);
      print("Error in sharing:=> ${onError.toString()}");

      return;
    });
  }

  String getBody() {
    String name = 'Name : ${widget.dependentName}\n';
    String diseaseName = 'Disease Name : ${widget.disease.name}\n';
    String diseaseDescription =
        'Disease Description : ${widget.disease.description}\n';
    String riskFactor = 'Risk Factor : ${widget.disease.Factor}\n';
    List<dynamic> causesList = widget.disease.causes;
    List<dynamic> symptomsList = widget.disease.symptoms;
    List<dynamic> actionsList = widget.disease.actions;
    List<Remedies> remediesList = widget.disease.remedies_list;

    String causes = causesList?.isNotEmpty == true ? 'Causes :\n' : '';
    for (int i = 0; i < causesList.length; i++) {
      causes = causes + '⦿ ${causesList[i]}\n';
    }
    String symptoms = symptomsList?.isNotEmpty == true ? 'Symptoms :\n' : '';
    for (int i = 0; i < symptomsList.length; i++) {
      symptoms = symptoms + '⦿ ${symptomsList[i]}\n';
    }

    String actions = actionsList?.isNotEmpty == true ? 'Actions :\n' : '';
    for (int i = 0; i < actionsList.length; i++) {
      actions = actions + '⦿ ${actionsList[i]}\n';
    }
    String remedies = remediesList?.isNotEmpty == true ? 'Remedies :\n' : '';
    if (widget.cancer == 'NotMelanoma') {
      for (int i = 0; i < remediesList.length; i++) {
        remedies = remedies + '⦿ ${remediesList[i].title}\n';
        if (remediesList[i].description != null) {
          remedies = remedies + "description: ${remediesList[i].description}\n";
        }

        for (int j = 0; j < remediesList[i].sub_list.length; j++) {
          remedies = remedies + '	      •	 ${remediesList[i].sub_list[j]} \n';
        }
      }
    }

    return '$name\n$diseaseName\n$diseaseDescription\n$riskFactor\n$causes\n$symptoms\n$actions\n$remedies';
  }

  Widget _oldWidgetData() {
    return Column(
      children: <Widget>[
        Container(
          color: Palette.grey5,
          height: 1,
          margin: EdgeInsets.only(
            top: 8.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 8.0, bottom: 8.0, right: 12.0),
          child: Text(
            Constants.COMMON_SYMPTOMS,
            style: Styles.workSans500(color: Colors.grey),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.disease.symptoms.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 12.0),
              child: Text(
                '- ' + widget.disease.symptoms[index],
                style: Styles.workSans600(color: Colors.black, fontSize: 14),
              ),
            );
          },
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 8.0, bottom: 8.0, right: 12.0),
          child: Text(
            Constants.COMMON_CAUSES,
            style: Styles.workSans500(color: Colors.grey),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.disease.causes.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 12.0),
                child: Text(
                  '- ' + widget.disease.causes[index],
                  style: Styles.workSans600(color: Colors.black, fontSize: 14),
                ),
              );
            }),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 8.0, bottom: 8.0, right: 12.0),
          child: Text(
            Constants.CAUSE_OF_ACTION,
            style: Styles.workSans500(color: Colors.grey),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.disease.actions.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 12.0),
                child: Text(
                  '- ' + widget.disease.actions[index],
                  style: Styles.workSans600(color: Colors.black, fontSize: 14),
                ),
              );
            }),
        SizedBox(
          height: Constants.screenHeight * 0.03,
        ),
        Container(
            color: Palette.grey5,
            height: 1,
            margin: EdgeInsets.only(
              top: 8.0,
            )),
        Padding(
          padding: const EdgeInsets.only(
              left: 40.0, right: 40.0, top: 10.0, bottom: 10.0),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  var reportFor = "";
                  if (widget.dependentName != null) {
                    if (widget.dependentName == 'Me') {
                      reportFor = "My Report";
                    } else {
                      reportFor = "${widget.dependentName} Report";
                    }
                  }
                  _launchURL(
                    widget.currentEmail,
                    reportFor,
                    widget.imageUrl,
                    context,
                  );
                },
                child: Text(
                  'Share with me',
                  style: Styles.workSans600(
                      color: Palette.primaryColor, fontSize: 14),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              GestureDetector(
                onTap: () {
                  var reportFor = "";
                  print('click on email share ${widget.dependentName}');
                  if (widget.dependentName != null) {
                    if (widget.dependentName == 'Me') {
                      reportFor = "My Report";
                    } else {
                      reportFor = "${widget.dependentName} Report";
                    }
                  }
                  _launchURL(
                    "",
                    reportFor,
                    widget.imageUrl,
                    context,
                  );
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      'Share to ',
                      style: Styles.workSans600(
                          color: Palette.primaryColor, fontSize: 14),
                    ),
                    Icon(
                      Icons.email,
                      color: Palette.primaryColor,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.hospitalList.isNotEmpty,
          child: Column(
            children: <Widget>[
              Container(
                color: Palette.grey6,
                width: Constants.screenWidth,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 10.0, bottom: 10.0, right: 12.0),
                  child: Text(
                    Constants.MEDICAL_STORE_NEAR,
                    style: Styles.workSans500(color: Colors.grey),
                  ),
                ),
              ),
              ListView.builder(
                itemCount: widget.hospitalList.length > 5
                    ? 5
                    : widget.hospitalList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return MedicalItem(
                      distance: '',
                      name: widget.hospitalList[i].name,
//                      distance: (calculateDistance(
//                                  Constants.latitude,
//                                  Constants.longitude,
//                                  widget.medicalList[i].geometry.location.lat,
//                                  widget.medicalList[i].geometry.location.lng))
//                              .toStringAsFixed(2) +
//                          'Miles away',
                      lat: widget.hospitalList[i].geometry.location.lat,
                      log: widget.hospitalList[i].geometry.location.lng,
                      address: widget.hospitalList[i].vicinity,
                      call: widget.hospitalList[i].phone_number);
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

// test@email.com
// test@123

// ignore: must_be_immutable
class MedicalItem extends StatefulWidget {
  String name;
  String distance;
  double lat;
  double log;
  String address;
  String call;

  MedicalItem({
    Key key,
    @required this.name,
    @required this.distance,
    @required this.lat,
    @required this.log,
    @required this.address,
    @required this.call,
  }) : super(key: key);

  @override
  _MedicalItemState createState() => _MedicalItemState();
}

class _MedicalItemState extends State<MedicalItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.name,
//                  maxLines: 1,
//                  overflow: TextOverflow.ellipsis,
                  style: Styles.workSans600(
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
              ),
              Text(
                widget.distance,
                style: Styles.workSans500New(
                    color: Palette.primaryColor, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.address,
                        maxLines: 1,
//                        overflow: TextOverflow.ellipsis,
                        style: Styles.subscriptionTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.call != null ? 'Call : ${widget.call}' : "",
                        style: Styles.subscriptionTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                children: <Widget>[
                  widget.call != null
                      ? GestureDetector(
                          onTap: () {
                            print(
                                'CALLLLL--->> ${widget.call.replaceAll(' ', '')}');
                            if (Platform.isAndroid) {
                              launch("tel://${widget.call}");
                            } else if (Platform.isIOS) {
                              launch(
                                  "tel://${widget.call.replaceAll(' ', '')}");
                            }
                          },
                          child: Image.asset(
                            Images.IC_CALL,
                            width: 40,
                          ),
                        )
                      : SizedBox(
                          height: 40,
                          width: 40,
                        ),
                  SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      print('latlong--->> ${widget.lat}  && ${widget.log}');
                      _openMap(widget.lat, widget.log, widget.name);
                    },
                    child: Image.asset(
                      Images.IC_MAP_DIRECTION,
                      width: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            color: Palette.grey5,
            height: 1,
            margin: EdgeInsets.only(
              top: 5.0,
            ),
          ),
        ],
      ),
    );
  }

  _openMap(double lat, double log, String name) async {
    if (Platform.isAndroid) {
      if (await MapLauncher.isMapAvailable(MapType.google)) {
        await MapLauncher.launchMap(
          mapType: MapType.google,
          coords: Coords(lat, log),
          title: name,
          description: 'medical',
        );
      }
    } else {
      if (await MapLauncher.isMapAvailable(MapType.apple)) {
        await MapLauncher.launchMap(
          mapType: MapType.apple,
          coords: Coords(lat, log),
          title: name,
          description: 'medical',
        );
      }
    }
  }
}

//_launchURL(String toMailId, String subject, String body, String attachmentUrl,
//    BuildContext context) async {
//  var data;
//  if (Platform.isAndroid) {
//    data = await getExternalStorageDirectory();
//  } else if (Platform.isIOS) {
//    data = await getApplicationSupportDirectory();
//  }
//
//  var firstPath = data.path + "/RashImages";
//  print("The click we get.... ==> $attachmentUrl");
//  await Directory(firstPath).create(recursive: true);
//  var response = await http.get(attachmentUrl).catchError((onError) {
//    Toast.show('Error in sharing, please try again later', context);
//    print("Error in sharing:=> ${onError.toString()}");
//    return;
//  });
//  File file = File(
//      firstPath + '/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg');
//  file.writeAsBytesSync(response.bodyBytes);
//  final Email email = Email(
//    body: body,
//    subject: subject,
//    recipients: [toMailId],
//    attachmentPath: file.path,
//    isHTML: false,
//  );
//
//  await FlutterEmailSender.send(email).catchError((onError) {
//    Toast.show('Error in sharing, please try again later', context);
//    print("Error in sharing:=> ${onError.toString()}");
//    return;
//  });
//}
