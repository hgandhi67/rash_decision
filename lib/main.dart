import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:rash_decision/aboutus/about_us_page.dart';
import 'package:rash_decision/base/AppStateModel.dart';
import 'package:rash_decision/base/constants.dart';
import 'package:rash_decision/base/overlay_camera_widget.dart';
import 'package:rash_decision/home/home_page.dart';
import 'package:rash_decision/legalinformation/legal_information_page.dart';
import 'package:rash_decision/model/disease_model.dart';
import 'package:rash_decision/profile/add_dependency_page.dart';
import 'package:rash_decision/profile/change_pass_page.dart';
import 'package:rash_decision/profile/profile_main_page.dart';
import 'package:rash_decision/profile/update_dependency_page.dart';
import 'package:rash_decision/profile/update_profile_page.dart';
import 'package:rash_decision/profile/view_dependancy_page.dart';
import 'package:rash_decision/reportandanalysis/report_analysis_page.dart';
import 'package:rash_decision/reprotanalyzing/error_page.dart';
import 'package:rash_decision/reprotanalyzing/rash_result_sucess_page.dart';
import 'package:rash_decision/reprotanalyzing/report_analyzing_page.dart';
import 'package:rash_decision/signin/forgot_pass_page.dart';
import 'package:rash_decision/signin/sign_in_page.dart';
import 'package:rash_decision/signup/sign_up_page.dart';
import 'package:rash_decision/splash/splash_screen_page.dart';
import 'package:rash_decision/subscriptionplans/subscription_plans_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base/routes.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    int sdkInt = androidDeviceInfo.version.sdkInt;
    if (sdkInt >= 21) {
      cameras = await availableCameras();
    }
  } else {
    cameras = await availableCameras();
  }
  InAppPurchaseConnection.enablePendingPurchases();
  runZoned(() {
    runApp(
      ChangeNotifierProvider<AppStateModel>(
        builder: (context) => AppStateModel(context),
        child: MyApp(),
      ),
    );
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences sharedPreferences;
  bool loginState = false;

  Future<bool> setSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(Constants.IS_RASH_DECISION_LOGIN);
  }

  @override
  void initState() {
    super.initState();
    loadDiseaseData();
    setSharedPref().then((value) {
      if (value == null) {
        value = false;
      }
      setState(() {
        loginState = value;
      });
    });
  }

  void loadDiseaseData() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("jsons/rashes.json");
    Constants.diseaseList = diseaseListFromJson(data);
    print('The json is : ${Constants.diseaseList.length}');
  }

  @override
  Widget build(BuildContext context) {
    setSharedPref();
    FirebaseAnalytics analytics = FirebaseAnalytics();
    analytics.logAppOpen();
    return MaterialApp(
      title: Constants.APP_NAME,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: analytics,
          onError: (onError) {
            analytics.logEvent(name: "Error", parameters: {
              "navigator-error": onError.toString(),
            });
          },
        ),
      ],
      routes: {
        AppRoutes.SIGN_IN: (BuildContext context) => SignInPage(),
        AppRoutes.FORGOT_PASSWORD: (BuildContext context) => ForgotPassPage(),
        AppRoutes.SIGN_UP: (BuildContext context) => SignUpPage(),
        AppRoutes.HOME_PAGE: (BuildContext context) => HomePage(),
        AppRoutes.ABOUT_US: (BuildContext context) => AboutUsPage(),
        AppRoutes.PROFILE_MAIN: (BuildContext context) {
          Constants.IS_BACK = false;
          return ProfileMainPage();
        },
        AppRoutes.UPDATE_PROFILE: (BuildContext context) => UpdateProfilePage(),
        AppRoutes.CHANGE_PASSWORD: (BuildContext context) => ChangePassPage(),
        AppRoutes.VIEW_DEPENDENCY: (BuildContext context) =>
            ViewDependencyPage(),
        AppRoutes.CAMERA_OVERLAY: (BuildContext context) => CameraOverlayWidget(
              cameras: cameras,
            ),
      },
      onGenerateRoute: (settings) {
        Widget screen;
        var args = settings.arguments;

        if (args is Map<String, dynamic>) {
          switch (settings.name) {
            case AppRoutes.UPDATE_DEPENDENCY:
              screen = _getUpdateDependencyPage(dataMap: args);
              break;
            case AppRoutes.ADD_DEPENDENCY:
              screen = _getAddDependencyPage(dataMap: args);
              break;
            case AppRoutes.REPORT_ANALYSIS:
              screen = _getReportAnalysisPage(dataMap: args);
              break;
            case AppRoutes.SUCCESS_RESULT:
              screen = _getResultSuccessPage(dataMap: args);
              break;
            case AppRoutes.REPORT_ANALYZING:
              screen = _getReportAnalyzingPage(dataMap: args);
              break;
            case AppRoutes.LEGAL_INFORMATION:
              screen = _getLegalInformationPage(dataMap: args);
              break;
            case AppRoutes.ERROR_PAGE:
              screen = _getErrorPage(dataMap: args);
              break;
            case AppRoutes.SUBSCRIPTION:
              screen = _getSubscriptionPage(dataMap: args);
              break;
          }
        }
        if (screen != null) {
          return MaterialPageRoute(
            builder: (context) => screen,
          );
        }
        return null;
      },
      initialRoute: AppRoutes.INIT_ROUTE,
      home: SplashScreenPage(),
    );
  }

  Widget _getUpdateDependencyPage({Map<String, dynamic> dataMap}) {
    return UpdateDependency(
      firstName: dataMap[AppRouteArgKeys.DEPENDENCY_FIRST_NAME],
      lastName: dataMap[AppRouteArgKeys.DEPENDENCY_LAST_NAME],
      dob: dataMap[AppRouteArgKeys.DEPENDENCY_DOB],
      relation: dataMap[AppRouteArgKeys.DEPENDENCY_RELATION],
      documentName: dataMap[AppRouteArgKeys.DEPENDENCY_NAME],
    );
  }

  Widget _getAddDependencyPage({Map<String, dynamic> dataMap}) {
    return AddDependencyPage(
      type: dataMap[AppRouteArgKeys.DEPENDENCY_ROUTE_TYPE],
      imageFile: dataMap[AppRouteArgKeys.DEPENDENCY_IMAGE_FILE],
    );
  }

  Widget _getLegalInformationPage({Map<String, dynamic> dataMap}) {
    return LegalInformation(
      pageTitle: dataMap[AppRouteArgKeys.LEGAL_INFO_PAGE_TITLE],
      pageData: dataMap[AppRouteArgKeys.LEGAL_INFO_PAGE_DATA],
    );
  }

  Widget _getReportAnalyzingPage({Map<String, dynamic> dataMap}) {
    return ReportAnalyzingPage(
      imageFile: dataMap[AppRouteArgKeys.REPORT_ANALYZING_IMAGE],
      fromDependant: dataMap[AppRouteArgKeys.IS_FROM_DEPENDENT],
    );
  }

  Widget _getErrorPage({Map<String, dynamic> dataMap}) {
    return ErrorPage(
      imageFile: dataMap[AppRouteArgKeys.REPORT_ANALYZING_IMAGE],
    );
  }

  Widget _getReportAnalysisPage({Map<String, dynamic> dataMap}) {
    print(
        "HELLOOOOOOOO 2====> ${dataMap[AppRouteArgKeys.REPORT_RASH_IMAGE_PATH]}");
    return ReportAnalysisPage(
      disease: dataMap[AppRouteArgKeys.DISEASE],
      imageUrl: dataMap[AppRouteArgKeys.DISEASE_IMAGE_URL],
      dependentName: dataMap[AppRouteArgKeys.DEPENDENT_NAME],
      imagePath: dataMap[AppRouteArgKeys.REPORT_RASH_IMAGE_PATH],
      hospitalList: List(),
      cancer: dataMap[AppRouteArgKeys.REPORT_RASH_CANCER],
    );
  }

  Widget _getResultSuccessPage({Map<String, dynamic> dataMap}) {
    print(
        "HELLOOOOOOOO 1====> ${dataMap[AppRouteArgKeys.REPORT_RASH_IMAGE_PATH]}");
    return RashResultSuccessPage(
      disease: dataMap[AppRouteArgKeys.DISEASE],
      imageUrl: dataMap[AppRouteArgKeys.DISEASE_IMAGE_URL],
      dependentName: dataMap[AppRouteArgKeys.DEPENDENT_NAME],
      imagePath: dataMap[AppRouteArgKeys.REPORT_RASH_IMAGE_PATH],
      reportName: dataMap[AppRouteArgKeys.REPORT_RASH_REPORT_NAME],
    );
  }

  Widget _getSubscriptionPage({Map<String, dynamic> dataMap}) {
    return SubscriptionsPage(
      isRashLogin: dataMap[AppRouteArgKeys.IS_RASH_DECISION_LOGIN],
      isRashSocialLogin: dataMap[AppRouteArgKeys.IS_RASH_SOCIAL_LOGIN],
      loggedInUserId: dataMap[AppRouteArgKeys.LOGGED_IN_USER_ID],
      isTrialUtilised: dataMap[AppRouteArgKeys.IS_TRIAL_UTILISED],
      reviewsTaken: dataMap[AppRouteArgKeys.REVIEWS_TAKEN],
      subsPageFrom: dataMap[AppRouteArgKeys.SUBS_PAGE_FROM],
    );
  }
}
