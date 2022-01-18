import 'package:drink/blocs/content/content_cubit.dart';
import 'package:drink/repositories/content_repository.dart';
import 'package:drink/screens/html_screens/html_screens.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/custom_snacks_bar.dart';
import 'package:drink/utility/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmationDialog extends StatefulWidget {
  const ConfirmationDialog({Key key}) : super(key: key);

  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  bool termsAndConditions = false;
  bool privacyPolicy = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 0.0, right: 0.0, left: 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: insideDialog(context),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              height: 42,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (termsAndConditions && privacyPolicy) {
                          AppNavigation.navigatorPopTrue(context);
                        } else if (!termsAndConditions && privacyPolicy) {
                          CustomSnacksBar.showSnackBar(context,
                              AppStrings.CONDITIONS_NOT_ACCEPTED_ERROR);
                        } else if (!privacyPolicy && termsAndConditions) {
                          CustomSnacksBar.showSnackBar(context,
                              AppStrings.PRIVACY_POLICY_NOT_ACCEPTED_ERROR);
                        } else if (!privacyPolicy && !termsAndConditions) {
                          CustomSnacksBar.showSnackBar(
                              context,
                              AppStrings
                                  .PRIVACY_AND_CONDITIONS_NOT_ACCEPTED_ERROR);
                        }
                      },
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.DARK_AMBER,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        height: 42,
                        child: Center(
                          child: Text(
                            AppStrings.ACCEPT,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 42,
                    width: 2,
                    color: AppColors.ORANGE,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => AppNavigation.navigatorPopFalse(context),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.DARK_AMBER,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          height: 42,
                          child: Center(
                              child: Text(
                            AppStrings.REJECT,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                          ))),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget insideDialog(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 7,
          ),
          Text(AppStrings.ALERT,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
          Text(
            AppStrings.AGREE_CONDITION,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Checkbox(
                  activeColor: AppColors.DARK_AMBER,
                  value: termsAndConditions,
                  onChanged: (value) {
                    setState(() {
                      termsAndConditions = value;
                    });
                  }),
              GestureDetector(
                onTap: () => AppNavigation.navigateTo(
                  context,
                  BlocProvider<ContentCubit>(
                    create: (context) => ContentCubit(ContentRepository()),
                    child: HTMLScreens(
                      htmlPath: AssetPaths.PRIVACY_HTML,
                      title: AppStrings.TERMS_AND_CONDITIONS,
                    ),
                  ),
                ),
                child: Text(
                  AppStrings.TERMS_AND_CONDITIONS,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              )
            ],
          ),
          Row(
            children: [
              Checkbox(
                  activeColor: AppColors.DARK_AMBER,
                  value: privacyPolicy,
                  onChanged: (value) {
                    setState(() {
                      privacyPolicy = value;
                    });
                  }),
              GestureDetector(
                onTap: () => AppNavigation.navigateTo(
                  context,
                  BlocProvider<ContentCubit>(
                    create: (context) => ContentCubit(ContentRepository()),
                    child: HTMLScreens(
                      htmlPath: AssetPaths.PRIVACY_HTML,
                      title: AppStrings.PRIVACY_POLICY,
                    ),
                  ),
                ),
                child: Text(
                  AppStrings.PRIVACY_POLICY,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              )
            ],
          ),
        ],
      );
}
