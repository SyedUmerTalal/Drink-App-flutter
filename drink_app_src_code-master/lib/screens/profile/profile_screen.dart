import 'dart:async';
import 'dart:io';
import 'package:drink/blocs/complete_profile/complete_profile_bloc.dart';
import 'package:drink/blocs/authentication/authentication_bloc.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/models/user.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/functions.dart';
import 'package:drink/utility/image_clipper.dart';
import 'package:drink/utility/loading_dialog.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';

import 'package:drink/widgets/image_source_sheet.dart';
import 'package:drink/widgets/raised_gradient_button.dart';
import 'package:drink/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:drink/utility/custom_snacks_bar.dart';

typedef ContextCallBack = void Function(BuildContext);

enum ImageType {
  camera,
  gallery,
}

class EditProfileView extends StatelessWidget {
  const EditProfileView({Key key, this.currentUser}) : super(key: key);
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompleteProfileBloc>(
      create: (context) => CompleteProfileBloc(
          authenticationRepository: context.read<AuthenticationRepository>()),
      child: ProfileScreen(
        title: AppStrings.EDIT_PROFILE,
        buttonText: AppStrings.UPDATE,
        initialCompleteName: currentUser.name,
        // initialDob:

        //  dob?.?isNotEmpty ?? false
        //     ? DateTime(int.parse(dob[0]), int.parse(dob[1]),
        //         int.parse(dob[2]))
        //     :
        // null,
        imagePath: currentUser.profilePicture,
        // initialGender: null,
        // currentUser.gender == AppStrings.SMALL_MALE
        //     ? AppStrings.MALE
        //     : AppStrings.FEMALE,
        onPressed: (cntx) {
          AppNavigation.navigatorPop(context);
        },
      ),
    );
  }
}

class CompleteProfileView extends StatelessWidget {
  const CompleteProfileView({
    Key key,
    this.currentUser,
  }) : super(key: key);
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompleteProfileBloc>(
      create: (context) => CompleteProfileBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: ProfileScreen(
        title: AppStrings.COMPLETE_PROFILE,
        buttonText: AppStrings.DONE,
        initialCompleteName: currentUser?.name,
        isCompleteProfile: true,
        // initialDob:

        // dob?.?isNotEmpty ?? false
        //     ? DateTime(int.parse(dob[0]),
        //         int.parse(dob[1]), int.parse(dob[2]))
        //     :
        // null,
        imagePath: currentUser?.profilePicture,
        // initialGender: null,
        // _currentUser.gender == AppStrings.SMALL_MALE
        //     ? AppStrings.MALE
        //     : AppStrings.FEMALE,
        onPressed: (cntx) {
          AppNavigation.navigatorPop(cntx);
        },
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key key,
    this.initialCompleteName,
    // this.initialGender,
    // this.initialDob,
    this.title,
    this.buttonText,
    this.imagePath,
    this.onPressed,
    this.isCompleteProfile = false,
  }) : super(key: key);
  final String initialCompleteName,
      //initialGender,
      title,
      buttonText;
  final ContextCallBack onPressed;
  final String imagePath;
  final bool isCompleteProfile;
  // final DateTime initialDob;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController;
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _genderFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();
  TextEditingController _dobController;
  ImagePicker _imagePicker;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  File _image;
  CompleteProfileBloc _completeProfileBloc;

  bool get isPopulated =>
      _nameController.text.isNotEmpty &&
      ((_image != null) || widget.title == AppStrings.EDIT_PROFILE);
  // &&
  // _dob != null &&
  // _selectedGender.isNotEmpty;
  bool isCPButtonEnabled(CompleteProfileState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _dobController = TextEditingController();
    _nameController = TextEditingController();
    _nameController.text = widget.initialCompleteName?.isNotEmpty ?? false
        ? widget.initialCompleteName
        : '';
    _nameController.addListener(onNameChagned);
  }

  Future<ImageType> _getImageType() async {
    final Completer<ImageType> completer = Completer();

    _scaffoldKey.currentState.showBottomSheet(
      (context) => imageSouceSheet(onCameraPressed: () {
        completer.complete(ImageType.camera);
        AppNavigation.navigatorPop(context);
      }, onGalleryPressed: () {
        completer.complete(ImageType.gallery);
        AppNavigation.navigatorPop(context);
      }),
    );
    return completer.future;
  }

  Widget _showNameInput(
    BuildContext context,
    CompleteProfileState state,
    ThemeType themeType,
  ) {
    return TextFieldInput(
      textEditingController: _nameController,
      themeType: themeType,
      validator: (value) =>
          (!state.isNameValid || value.isEmpty) ? AppStrings.NAME_ERROR : null,
      inputAction: TextInputAction.next,
      inputType: TextInputType.name,
      focusNode: _nameFocus,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? Colors.black : Colors.white,
      ),
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? Colors.black : Colors.white,
      ),
      formFieldSubmitted: (value) {
        _nameFocus.unfocus();
        FocusScope.of(context).requestFocus(_genderFocus);
      },
      hintText: AppStrings.COMPLETE_NAME,
    );
  }

  Future<File> _cropImage(File image) async {
    final File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: AppStrings.APP_TITLE,
            toolbarColor: AppColors.CIRCLE_YELLOW,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    return croppedFile;
  }

  Widget _showPictureAvatar(
    BuildContext context,
    CompleteProfileState state,
    ThemeType themeType,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 1,
                color:
                    themeType == ThemeType.light ? Colors.black : Colors.white,
                style: BorderStyle.solid,
              )),
          child: Center(
              child: ClipOval(
            clipper: CircleRevealClipper(),
            child: Container(
              height: 108,
              width: 108,
              color: Colors.white,
              child: _image == null
                  ? widget.imagePath?.isEmpty ?? true
                      ? Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Image.asset(
                            AssetPaths.ADD_PHOTO_ICON,
                            fit: BoxFit.scaleDown,
                            color: AppColors.CIRCLE_YELLOW,
                          ),
                        )
                      : Image.network(
                          API.PHOTO_URL + widget.imagePath,
                          fit: BoxFit.cover,
                        )
                  : Image.file(
                      File(_image.path),
                      fit: BoxFit.cover,
                    ),
            ),
          )),
        ),
        Positioned(
            right: -10,
            child: IconButton(
                icon: Container(
                    height: 30,
                    width: 30,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.CIRCLE_YELLOW,
                    ),
                    child: Icon(
                      FontAwesomeIcons.plus,
                      size: 14,
                      color: Colors.white,
                    )),
                onPressed: () => Future.delayed(Duration.zero, () async {
                      final _imageType = await _getImageType();
                      PickedFile _file;
                      if (_imageType == ImageType.camera) {
                        _file = await _imagePicker.getImage(
                            source: ImageSource.camera);
                      } else {
                        _file = await _imagePicker.getImage(
                            source: ImageSource.gallery);
                      }
                      _image = File(_file.path);
                      _image = await _cropImage(_image);
                      setState(() {});
                    })))
      ],
    );
  }

  Widget _doneButton(CompleteProfileState state) {
    return RaisedGradientButton(
        child: Text(
          AppStrings.DONE,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: isCPButtonEnabled(state)
            ? () {
                if (_image != null) {
                  context.read<CompleteProfileBloc>().add(
                        Submitted(
                          // dateofBirth: _dob,
                          name: _nameController.text,
                          // gender: _selectedGender,
                          profilePicture: _image,
                          token: context
                              .read<AuthenticationBloc>()
                              .currentUser
                              .token,
                        ),
                      );
                } else {
                  if (_nameController.text != widget.initialCompleteName)
                    context.read<CompleteProfileBloc>().add(
                          Submitted(
                            // dateofBirth: _dob,
                            name: _nameController.text,
                            // gender: _selectedGender,
                            // profilePicture: _image,
                            token: context
                                .read<AuthenticationBloc>()
                                .currentUser
                                .token,
                          ),
                        );
                }
                FocusScope.of(context).unfocus();

                // if (_formKey.currentState.validate()) {
                //   if (_image == null) {
                //     // AppNavigation.showToast(AppStrings.);
                //   }
                // }
              }
            : () {
                if (_image == null || widget.imagePath != null) {
                  AppNavigation.showToast(
                      message: AppStrings.PROFILE_PICTURE_ERROR);
                } else if (!state.isNameValid) {
                  AppNavigation.showToast(message: AppStrings.NAME_ERROR);
                } else {
                  AppNavigation.showToast(
                      message: AppStrings.COMPLETE_PROFILE_FORM);
                }
                _formKey.currentState.validate();
                FocusScope.of(context).unfocus();
              });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Container(
          decoration: themeState.type == ThemeType.light
              ? backGroundImgDecorationLight
              : backGroundImgDecoration,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: widget.isCompleteProfile
                  ? SizedBox.shrink()
                  : IconButton(
                      icon: Platform.isAndroid
                          ? Icon(
                              Icons.arrow_back,
                              color: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                            )
                          : Icon(
                              Icons.arrow_back_ios,
                              color: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                      onPressed: () {
                        AppNavigation.navigatorPop(context);
                      },
                    ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading:
                  widget.imagePath?.isEmpty ?? false ? false : true,
              title: Text(
                widget.title,
                style: TextStyle(
                  color: themeState.type == ThemeType.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: getHeight(context) - kToolbarHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child:
                      BlocConsumer<CompleteProfileBloc, CompleteProfileState>(
                    listener: (context, state) {
                      if (state.isSubmitting) {
                        LoadingDialog.show(context);
                      } else if (state.isFailure) {
                        LoadingDialog.hide(context);
                        CustomSnacksBar.showSnackBar(context, state.message);
                      } else if (state.isSuccess) {
                        LoadingDialog.hide(context);
                      }
                    },
                    builder: (context, state) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Spacer(flex: 3),
                            _showPictureAvatar(context, state, themeState.type),
                            Spacer(flex: 2),
                            _showNameInput(context, state, themeState.type),
                            // Spacer(
                            //   flex: 1,
                            // ),
                            // _genderDropDown(context, state),
                            // Spacer(
                            //   flex: 1,
                            // ),
                            // _showDOBPicker(context, state),
                            Spacer(
                              flex: 2,
                            ),
                            _doneButton(state),
                            Spacer(
                              flex: 7,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onNameChagned() {
    if (_completeProfileBloc != null) {
      _completeProfileBloc.add(
        NameChanged(_nameController.text),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    _genderFocus.dispose();
    _dobFocus.dispose();
    _dobController.dispose();
    super.dispose();
  }
}
