import 'package:drink/utility/colors.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:flutter/material.dart';

class DealAlertDialog extends StatefulWidget {
  const DealAlertDialog({
    Key key,
    this.message,
  }) : super(key: key);
  final String message;

  @override
  _DealAlertDialogState createState() => _DealAlertDialogState();
}

//TODO use single dialog
class _DealAlertDialogState extends State<DealAlertDialog> {
  bool termsAndConditions = false;
  bool privacyPolicy = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context, widget.message),
    );
  }

  Widget dialogContent(BuildContext context, String message) {
    return Container(
        margin: EdgeInsets.only(bottom: 0.0, right: 0.0, left: 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: insideDialog(context, message),
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
                        AppNavigation.navigatorPopTrue(context);
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
                            AppStrings.SHOW_ALL,
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
                            AppStrings.CANCEL,
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

  Widget insideDialog(BuildContext context, String message) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 7,
          ),
          Text(AppStrings.DEAL_ALERTS,
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8,
          ),
        ],
      );
}
