import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rash_decision/base/AppStateModel.dart';
import 'package:rash_decision/base/appbar/app_bar.dart';
import 'package:rash_decision/base/constants.dart';
import 'package:rash_decision/base/modal_progress_indicator.dart';
import 'package:rash_decision/base/theme/palette.dart';
import 'package:rash_decision/base/theme/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class UpdateProfilePage extends StatefulWidget {
  UpdateProfilePage();

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  String firstName = '';
  bool validateFirstName;
  String lastName = '';
  bool validateLastName;
  bool isLoading = false;
  bool validateZipCode;
  String currentEmail = '';
  String currentImage = '';
  String zipCode = '';
  final FocusNode _zipFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();
  FirebaseUser currentLoggedUser;
  String currentLoggedUserId;
  final TextEditingController _firstNameEditingController =
      TextEditingController();
  final TextEditingController _lastNameEditingController =
      TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _dobEditingController = TextEditingController();
  final TextEditingController _zipEditingController = TextEditingController();
  bool validateDob;

  File profilePicFile;

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  Future<SharedPreferences> getSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();

    getSharedPref().then((sharedPrefs) {
      currentLoggedUserId = sharedPrefs.getString(Constants.LOGGED_IN_USER_ID);
      Firestore.instance
          .collection('users')
          .document(currentLoggedUserId)
          .get()
          .then((doc) {
        if (doc.data != null) {
          setState(() {
            currentEmail = doc.data['email'];
            currentImage = doc.data['image'];
            _emailEditingController.text = currentEmail ?? '';
            _firstNameEditingController.text = doc.data['firstname'];
            _lastNameEditingController.text = doc.data['lastname'];
            if (_firstNameEditingController.text.isNotEmpty) {
              validateFirstName = true;
            }
            if (_lastNameEditingController.text.isNotEmpty) {
              validateLastName = true;
            }
            _dobEditingController.text = doc.data['dob'];

            if (_dobEditingController.text.isNotEmpty) {
              validateDob = true;
            }
            _zipEditingController.text = doc.data['zip'];

            if (_zipEditingController.text.isNotEmpty) {
              validateZipCode = true;
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _dobFocusNode.dispose();
    _firstNameEditingController.dispose();
    _lastNameEditingController.dispose();
    _emailEditingController.dispose();
    _dobEditingController.dispose();
    _zipEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget.getAppBarWidgetWithLeading(
        context: context,
        appBarTitle: Constants.UPDATE_PROFILE,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        color: Palette.white,
        opacity: 0.6,
        child: Stack(
          children: <Widget>[
            Image.asset(
              'images/grayscale_bg.jpg',
              fit: BoxFit.cover,
              height: Constants.screenHeight,
              width: Constants.screenWidth,
            ),
            SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: _getProfileImageLayout(),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          _fullNameWidget(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _emailWidget(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _dobWidget(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _zipWidget(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          _buildSendLinkField(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getProfileImageLayout() {
    return Stack(
      children: <Widget>[
        Container(
          height: 120.0,
          width: 120.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(35.0),
            color: Colors.blueAccent,
            image: DecorationImage(
              image: profilePicFile != null
                  ? FileImage(profilePicFile)
                  : (currentImage != null && currentImage.isNotEmpty)
                      ? NetworkImage(currentImage)
                      : AssetImage('images/profile_default.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 1.0,
          top: 1,
          child: InkWell(
            onTap: () {
              _showDialog();
            },
            child: Image.asset(
              'images/edit_pic.png',
              height: 40.0,
              width: 40.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _zipWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          Constants.ZIP_CODE,
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
            zipCode = changedText;
            if (Validator.validateZipCode(zipCode)) {
              validateZipCode = true;
            } else {
              validateZipCode = false;
            }
          },
          textAlign: TextAlign.start,
          style: Styles.normalGreyColoredTextStyle,
          autocorrect: false,
          enableInteractiveSelection: false,
          keyboardType: TextInputType.number,
          cursorColor: Palette.primaryColor,
          controller: _zipEditingController,
          textInputAction: TextInputAction.done,
          focusNode: _zipFocusNode,
          onSubmitted: (_) {
            _zipFocusNode.unfocus();
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.grey[300]
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.grey[300]
              ),
            ),
            errorText: (validateZipCode == null || validateZipCode)
                ? null
                : 'Please enter zip code',
            errorStyle: Styles.smallButtonTextStyle(
              color: Palette.redColor,
            ),
            filled: true,
            fillColor: Palette.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSendLinkField() {
    print('_buildSendLinkField-->> ${validateDob}');
    return Container(
      width: MediaQuery.of(context).size.width,
      child: MaterialButton(
        key: Key('saveButton'),
        color: Palette.appBarBgColor,
        onPressed: () {
          Provider.of<AppStateModel>(context).isInternetConnected().then((value){
            if(value){
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
              } else if (validateZipCode == null || !validateZipCode) {
                Toast.show('Please enter zip code.', context);
                setState(() {
                  validateZipCode = false;
                });
                return;
              }
              _startLoading();
              if (profilePicFile != null) {
                _uploadWithProfilePic();
              } else {
                _uploadWithoutProfilePic();
              }
            }else{
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
        padding: EdgeInsets.all(15.0),
        child: Text(
          'Update',
          style: Styles.buttonTextStyle(
            color: Palette.white,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
      ),
    );
  }

  void _uploadWithoutProfilePic() {
    getSharedPref().then((sharedPref) {
      Firestore.instance
          .collection('users')
          .document(sharedPref.get(Constants.LOGGED_IN_USER_ID))
          .updateData({
        "name": _firstNameEditingController.text +
            " " +
            _lastNameEditingController.text,
        "firstname": _firstNameEditingController.text,
        "lastname": _lastNameEditingController.text,
        "dob": _dobEditingController.text,
        "zip": _zipEditingController.text,
      }).then((_) {
        _stopLoading();
        Toast.show('Profile updated', context);
      }).catchError((error) {
        _stopLoading();
        Toast.show('Error updating profile, please try again later.', context);
      });
    });
  }

  void _uploadWithProfilePic() {
    getSharedPref().then((sharedPref) {
      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child(sharedPref.getString(Constants.LOGGED_IN_USER_ID))
          .child('profile_pic.png');
      StorageUploadTask uploadTask = ref.putFile(profilePicFile);
      uploadTask.onComplete.then((value) {
        value.ref.getDownloadURL().then((url) {
          Firestore.instance
              .collection('users')
              .document(sharedPref.get(Constants.LOGGED_IN_USER_ID))
              .updateData({
            "name": _firstNameEditingController.text +
                " " +
                _lastNameEditingController.text,
            "firstname": _firstNameEditingController.text,
            "lastname": _lastNameEditingController.text,
            "dob": _dobEditingController.text,
            "zip": _zipEditingController.text,
            "image": url,
          }).then((_) {
            profilePicFile=null;
            _stopLoading();
            Toast.show('Profile updated', context);
          }).catchError((error) {
            _stopLoading();
            Toast.show(
                'Error updating profile, please try again later.', context);
          });
        }).catchError((onError) {
          _stopLoading();
          print("Error with getting url :=> ${onError.toString()}");
          Toast.show('Rash data not found!', context);
        });
      }).catchError((onError) {
        _stopLoading();
        print("Error with completing :=> ${onError.toString()}");
        Toast.show('Rash data not found!', context);
      });
    });
  }

  Widget _fullNameWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
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
                  if (Validator.validateFullName(firstName)) {
                    validateFirstName = true;
                  } else {
                    validateFirstName = false;
                  }
                },
                textAlign: TextAlign.start,
                style: Styles.normalGreyColoredTextStyle,
                autocorrect: false,
                enableInteractiveSelection: false,
                enabled: true,
                readOnly: true,
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
                    borderSide: BorderSide(
                      color: Colors.grey[300]
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(
                      color: Colors.grey[300]
                    ),
                  ),
                  errorText: (validateFirstName == null || validateFirstName)
                      ? null
                      : 'Please enter first name',
                  errorStyle: Styles.smallButtonTextStyle(
                    color: Palette.redColor,
                  ),
                  filled: true,
                  fillColor: Palette.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: Column(
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
                  if (Validator.validateFullName(lastName)) {
                    validateLastName = true;
                  } else {
                    validateLastName = false;
                  }
                },
                textAlign: TextAlign.start,
                style: Styles.normalGreyColoredTextStyle,
                autocorrect: false,
                enableInteractiveSelection: false,
                enabled: true,
                readOnly: true,
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
                    borderSide: BorderSide(
                      color: Colors.grey[300]
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(
                      color: Colors.grey[300]
                    ),
                  ),
                  errorText: (validateLastName == null || validateLastName)
                      ? null
                      : 'Please enter last name',
                  errorStyle: Styles.smallButtonTextStyle(
                    color: Palette.redColor,
                  ),
                  filled: true,
                  fillColor: Palette.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _emailWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: Styles.buttonTextStyle(
            size: 16.0,
            color: Palette.textColor,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        TextField(
          textAlign: TextAlign.start,
          style: Styles.normalGreyColoredTextStyle,
          autocorrect: false,
          cursorColor: Palette.primaryColor,
          controller: _emailEditingController,
          enableInteractiveSelection: false,
          enabled: true,
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.grey[300]
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.grey[300]
              ),
            ),
            errorStyle: Styles.smallButtonTextStyle(
              color: Palette.redColor,
            ),
            filled: true,
            fillColor: Palette.white,
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
          'Date of Birth',
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
            DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              minTime: DateTime(1900, 1, 1),
              maxTime: DateTime.now(),
              onConfirm: (date) {
                setState(() {
                  _dobEditingController.text =
                      '${date.day}/${date.month}/${date.year}';
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
            FocusScope.of(context).requestFocus(_zipFocusNode);
          },
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.grey[300]
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                color: Colors.grey[300]
              ),
            ),
            errorText: (validateDob == null || validateDob)
                ? null
                : 'Please select Date of Birth.',
            errorStyle: Styles.smallButtonTextStyle(
              color: Palette.redColor,
            ),
            filled: true,
            fillColor: Palette.white,
          ),
        ),
      ],
    );
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

  void _showDialog() {
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
              right: 15.0,
              left: 15.0,
              bottom: 25.0,
            ),
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Select Mode',
                  style: Styles.subscriptionTextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _profileImage(imageSource: ImageSource.camera);
                  },
                  padding: const EdgeInsets.all(12.0),
                  minWidth: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    'Camera',
                    style: Styles.subscriptionTextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Palette.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Palette.appBarBgColor,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _profileImage(imageSource: ImageSource.gallery);
                  },
                  padding: const EdgeInsets.all(12.0),
                  minWidth: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    'Gallery',
                    style: Styles.subscriptionTextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Palette.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Palette.appBarBgColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _profileImage({@required ImageSource imageSource}) async {
    var image = await ImagePicker.pickImage(source: imageSource);
    setState(() {
      profilePicFile = image;
    });
  }
}

class Validator {
  static bool validateFullName(String fullName) {
    if (fullName == '' || fullName.isEmpty) {
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

  static bool validateZipCode(String zipCode) {
    if (zipCode == '' || zipCode.isEmpty) {
      return false;
    }
    return true;
  }
}
