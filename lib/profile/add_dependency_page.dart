import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:rash_decision/base/AppStateModel.dart';
import 'package:rash_decision/base/appbar/app_bar.dart';
import 'package:rash_decision/base/constants.dart';
import 'package:rash_decision/base/modal_progress_indicator.dart';
import 'package:rash_decision/base/theme/palette.dart';
import 'package:rash_decision/base/theme/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AddDependencyPage extends StatefulWidget {
  final int type;
  final File imageFile;

  const AddDependencyPage({
    Key key,
    @required this.type,
    this.imageFile,
  }) : super(key: key);

  @override
  _AddDependencyPageState createState() => _AddDependencyPageState();
}

class _AddDependencyPageState extends State<AddDependencyPage> {
  String relation = '';
  String dob = '';
  String firstName = '';
  String lastName = '';
  bool validateFirstName;
  bool validateLastName;
  bool validateRelation;
  bool validateDob;

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();
  final FocusNode _relationFocusNode = FocusNode();

  final TextEditingController _firstNameEditingController =
      TextEditingController();
  final TextEditingController _lastNameEditingController =
      TextEditingController();
  final TextEditingController _dobEditingController = TextEditingController();
  final TextEditingController _relationEditingController =
      TextEditingController();

  bool isLoading = false;

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    setSharedPref();
  }

  void setSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      //prefs
    });
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _dobFocusNode.dispose();
    _relationFocusNode.dispose();
    _firstNameEditingController.dispose();
    _lastNameEditingController.dispose();
    _dobEditingController.dispose();
    _relationEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.getAppBarWidgetWithLeading(
        context: context,
        appBarTitle: Constants.ADD_DEPENDENCY,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        color: Palette.white,
        opacity: 0.6,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: Constants.screenHeight * 0.02,
                          ),
                          _firstNameWidget(), //name
                          SizedBox(
                            height: Constants.screenHeight * 0.02,
                          ),
                          _lastNameWidget(),
                          SizedBox(
                            height: Constants.screenHeight * 0.02,
                          ),
                          _dobWidget(), //dob
                          SizedBox(
                            height: Constants.screenHeight * 0.02,
                          ),
                          _relationWidget(), //relation
                          SizedBox(
                            height: Constants.screenHeight * 0.03,
                          ),
                          _buildSendLinkField(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _firstNameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          Constants.FIRST_NAME,
          style: Styles.buttonTextStyle(
            size: 16.0,
            color: Palette.textColor,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        TextField(
          onChanged: (changedText) {
            firstName = changedText;
            if (Validator.validateFirstName(firstName)) {
              validateFirstName = true;
            } else {
              validateFirstName = false;
            }
          },
          textAlign: TextAlign.start,
          style: Styles.normalGreyColoredTextStyle,
          autocorrect: false,
          cursorColor: Palette.primaryColor,
          controller: _firstNameEditingController,
          textInputAction: TextInputAction.next,
          focusNode: _firstNameFocusNode,
          onSubmitted: (_) {
            _firstNameFocusNode.unfocus();
            FocusScope.of(context).requestFocus(_lastNameFocusNode);
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: Colors.grey[300]),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: Colors.grey[300]),
            ),
            errorText: (validateFirstName == null || validateFirstName)
                ? null
                : 'Please enter first name',
            errorStyle: Styles.smallButtonTextStyle(
              color: Palette.redColor,
            ),
            filled: true,
            fillColor: Colors.white,
//        hintStyle: Styles.editTextHintTextStyle,
//        hintText: Constants.FIRST_NAME,
          ),
        ),
      ],
    );
  }

  Widget _lastNameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          Constants.LAST_NAME,
          style: Styles.buttonTextStyle(
            size: 16.0,
            color: Palette.textColor,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        TextField(
          onChanged: (changedText) {
            lastName = changedText;
            if (Validator.validateLastName(lastName)) {
              validateLastName = true;
            } else {
              validateLastName = false;
            }
          },
          textAlign: TextAlign.start,
          style: Styles.normalGreyColoredTextStyle,
          autocorrect: false,
          cursorColor: Palette.primaryColor,
          controller: _lastNameEditingController,
          textInputAction: TextInputAction.next,
          focusNode: _lastNameFocusNode,
          onSubmitted: (_) {
            _lastNameFocusNode.unfocus();
            FocusScope.of(context).requestFocus(_dobFocusNode);
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: Colors.grey[300]),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: Colors.grey[300]),
            ),
            errorText: (validateLastName == null || validateLastName)
                ? null
                : 'Please enter last name',
            errorStyle: Styles.smallButtonTextStyle(
              color: Palette.redColor,
            ),
            filled: true,
            fillColor: Colors.white,
//            hintStyle: Styles.editTextHintTextStyle,
//            hintText: Constants.LAST_NAME,
          ),
        ),
      ],
    );
  }

  Widget _dobWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Date of Birth",
          style: Styles.buttonTextStyle(
            size: 16.0,
            color: Palette.textColor,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        TextField(
          onTap: () {
            print("HERLLO");
            DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              minTime: DateTime(1900, 1, 1),
              maxTime: DateTime.now(),
              onConfirm: (date) {
                setState(() {
                  dob = '${date.day}/${date.month}/${date.year}';
                  _dobEditingController.text = dob;
                  validateDob = true;
                });
              },
              locale: LocaleType.en,
            );
          },
          textAlign: TextAlign.start,
          style: Styles.normalGreyColoredTextStyle,
          autocorrect: false,
          enableInteractiveSelection: false,
          cursorColor: Palette.primaryColor,
          controller: _dobEditingController,
          textInputAction: TextInputAction.next,
          focusNode: _dobFocusNode,
          onSubmitted: (_) {
            _dobFocusNode.unfocus();
            FocusScope.of(context).requestFocus(_relationFocusNode);
          },
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: Colors.grey[300]),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: Colors.grey[300]),
            ),
            errorText: (validateDob == null || validateDob)
                ? null
                : 'Please select Date of Birth.',
            errorStyle: Styles.smallButtonTextStyle(
              color: Palette.redColor,
            ),
            filled: true,
            fillColor: Colors.white,
//            hintStyle: Styles.editTextHintTextStyle,
//            hintText: Constants.DOB,
          ),
        ),
      ],
    );
  }

  Widget _relationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          Constants.RELATION,
          style: Styles.buttonTextStyle(
            size: 16.0,
            color: Palette.textColor,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        TextField(
          onChanged: (changedText) {
            relation = changedText;
            if (Validator.validateRelation(relation)) {
              validateRelation = true;
            } else {
              validateRelation = false;
            }
          },
          textAlign: TextAlign.start,
          style: Styles.normalGreyColoredTextStyle,
          autocorrect: false,
          cursorColor: Palette.primaryColor,
          controller: _relationEditingController,
          textInputAction: TextInputAction.done,
          focusNode: _relationFocusNode,
          onSubmitted: (_) {
            _relationFocusNode.unfocus();
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.grey[300],
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.grey[300],
              ),
            ),
            errorText: (validateRelation == null || validateRelation)
                ? null
                : 'Please enter relation',
            errorStyle: Styles.smallButtonTextStyle(
              color: Palette.redColor,
            ),
            filled: true,
            fillColor: Colors.white,
//            hintStyle: Styles.editTextHintTextStyle,
//            hintText: Constants.RELATION,
          ),
        ),
      ],
    );
  }

  Widget _buildSendLinkField() {
    return Container(
      width: MediaQuery.of(context).size.width,
//      margin: EdgeInsets.symmetric(horizontal: 30),
      child: RaisedButton(
        key: Key('saveButton'),
        color: Palette.appBarBgColor,
        onPressed: () {
          Provider.of<AppStateModel>(context)
              .isInternetConnected()
              .then((value) {
            if (value) {
              _addDependency();
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Please check your Internet connection.",
                      style: Styles.workSans500New(
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
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          });
        },
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Text(
          Constants.SUBMIT,
          style: Styles.buttonTextStyle(
            color: Palette.white,
          ),
        ),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }

  void _addDependency() {
    if (validateFirstName == null || !validateFirstName) {
      Toast.show('Please enter full name.', context);
      setState(() {
        validateFirstName = false;
      });
      return;
    } else if (validateDob == null || !validateDob) {
      Toast.show('Please select date of birth.', context);
      setState(() {
        validateDob = false;
      });
      return;
    } else if (validateRelation == null || !validateRelation) {
      Toast.show('Please enter zip code.', context);
      setState(() {
        validateRelation = false;
      });
      return;
    }

    _startLoading();
    Firestore.instance
        .collection('dependency')
        .document(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
        .collection(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
        .document(_firstNameEditingController.text +
            '_' +
            _relationEditingController.text)
        .setData({
      'first_name': _firstNameEditingController.text,
      'last_name': _lastNameEditingController.text,
      'dob': _dobEditingController.text,
      'relation': _relationEditingController.text,
    }).then((_) {
      _stopLoading();
      Toast.show('Dependent is added', context);
      print("HERE TYPE IS : ===> ${widget.type}");
      if (widget.type == 2) {
//        Navigator.of(context).popAndPushNamed(
//          AppRoutes.REPORT_ANALYZING,
//          arguments: {
//            AppRouteArgKeys.REPORT_ANALYZING_IMAGE: widget.imageFile,
//            AppRouteArgKeys.IS_FROM_DEPENDENT: _fullNameEditingController.text,
//          },
//        );
        Provider.of<AppStateModel>(context).currentDependencyListChanged =
            '${_firstNameEditingController.text ?? ''} ${_lastNameEditingController.text ?? ''}';
        Navigator.of(context).pop();
      } else {
        Provider.of<AppStateModel>(context).setDependencyAddedEvent(true);
        Navigator.of(context).pop();
      }
    }).catchError((error) {
      _stopLoading();
      Toast.show('Error in adding dependency, please try again later', context);
    });
  }

  void _startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void _stopLoading() {
    setState(() {
      isLoading = false;
    });
  }
}

class Validator {
  static bool validateFirstName(String firstName) {
    if (firstName == '' || firstName.isEmpty) {
      return false;
    }
    return true;
  }

  static bool validateLastName(String lastName) {
    if (lastName == '' || lastName.isEmpty) {
      return false;
    }
    return true;
  }

  static bool validateRelation(String relation) {
    if (relation == '' || relation.isEmpty) {
      return false;
    }
    return true;
  }

  static bool validateDOB(String dob) {
    if (dob == '' || dob.isEmpty) {
      return false;
    }
    return true;
  }
}
