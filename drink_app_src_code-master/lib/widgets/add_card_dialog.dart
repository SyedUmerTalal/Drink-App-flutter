import 'dart:developer';

import 'package:drink/blocs/credit_card/credit_card_form/credit_card_form_bloc.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/custom_snacks_bar.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCreditCardDialog extends StatefulWidget {
  const AddCreditCardDialog({Key key}) : super(key: key);

  @override
  _AddCreditCardDialogState createState() => _AddCreditCardDialogState();
}

class _AddCreditCardDialogState extends State<AddCreditCardDialog> {
  final FocusNode _cardNumberFocus = FocusNode();

  final FocusNode _expMonthFocus = FocusNode();

  final FocusNode _expYearFocus = FocusNode();

  final FocusNode _ccvFocus = FocusNode();

  TextEditingController _cardNumber;

  TextEditingController _expMonth;

  TextEditingController _expYear;

  TextEditingController _cvv;
  @override
  void initState() {
    _cardNumber = TextEditingController();
    _expMonth = TextEditingController();
    _expYear = TextEditingController();
    _cvv = TextEditingController();

    _cardNumber.addListener(() {
      context
          .read<CreditCardFormBloc>()
          .add(CardNumberChanged(cardNumber: _cardNumber.text));
    });
    _expMonth.addListener(() {
      if (_expMonth.text.isNotEmpty) {
        context
            .read<CreditCardFormBloc>()
            .add(MonthChanged(selectedMonth: int.parse(_expMonth.text)));
      }
    });
    _expYear.addListener(() {
      context.read<CreditCardFormBloc>().add(YearChanged(year: _expYear.text));
    });
    _cvv.addListener(() {
      context.read<CreditCardFormBloc>().add(CVVChanged(cvv: _cvv.text));
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: BlocListener<CreditCardFormBloc, CreditCardFormState>(
        listener: (context, state) {
          if (state.isLoaded) {
            Navigator.of(context).pop(true);
          } else if (state.isFailure) {
            CustomSnacksBar.showSnackBar(context, state.message);
          }
        },
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned(
              left: 0,
              child: Image.asset(
                AssetPaths.ICON_ADD_CARD,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.36475,
              ),
            ),
            dialogContent(context),
          ],
        ),
      ),
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
                    child: BlocBuilder<CreditCardFormBloc, CreditCardFormState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap: !state.isLoading
                              ? () {
                                  if (state.isFormValid) {
                                    try {
                                      context.read<CreditCardFormBloc>().add(
                                            CreditCardSubmitted(
                                              cardNumber: _cardNumber.text,
                                              selectedMonth:
                                                  int.parse(_expMonth.text),
                                              year: _expYear.text,
                                              ccv: _cvv.text,
                                            ),
                                          );
                                    } catch (e) {
                                      log(e.toString());
                                      rethrow;
                                    }
                                  } else {
                                    _formKey.currentState.validate();
                                  }
                                }
                              : null,
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
                                AppStrings.ADD,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
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

  Widget insideDialog(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 16,
          ),
          Text(
            AppStrings.ADD_CARD,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24,
            ),
            child: BlocBuilder<CreditCardFormBloc, CreditCardFormState>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      textInputField(
                        TextInputAction.next,
                        _cardNumberFocus,
                        (value) {
                          _cardNumberFocus.unfocus();
                          FocusScope.of(context).requestFocus(_expMonthFocus);
                        },
                        _cardNumber,
                        AppStrings.CARD_NUMBER,
                        16,
                        (value) =>
                            state.isCardNumberValid ? null : state.message,
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          CardNumberInputFormatter()
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: textInputField(
                                TextInputAction.next, _expMonthFocus, (value) {
                              _expMonthFocus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_expYearFocus);
                            },
                                _expMonth,
                                AppStrings.EXP_MONTH,
                                2,
                                (value) =>
                                    state.isMonthValid ? null : state.message,
                                inputFormatter: [
                                  LengthLimitingTextInputFormatter(2),
                                ]),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: textInputField(
                                TextInputAction.next, _expYearFocus, (value) {
                              _expYearFocus.unfocus();
                              FocusScope.of(context).requestFocus(_ccvFocus);
                            },
                                _expYear,
                                AppStrings.EXP_YEAR,
                                4,
                                (value) =>
                                    state.isYearValid ? null : state.message,
                                inputFormatter: [
                                  LengthLimitingTextInputFormatter(4),
                                ]),
                          ),
                        ],
                      ),
                      textInputField(TextInputAction.done, _ccvFocus, (value) {
                        _ccvFocus.unfocus();
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState.validate()) {
                          Navigator.of(context).pop();
                        }
                      }, _cvv, AppStrings.CCV, 3,
                          (value) => state.isCCVValid ? null : state.message,
                          inputFormatter: [
                            LengthLimitingTextInputFormatter(3),
                          ]),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      );

  Widget textInputField(
    TextInputAction textInputAction,
    FocusNode focusNode,
    Function(String) onFormFieldSubmitted,
    TextEditingController controller,
    String hintText,
    int lengthOfInput,
    String Function(String) validator, {
    @required List<TextInputFormatter> inputFormatter,
  }) {
    return BlocBuilder<CreditCardFormBloc, CreditCardFormState>(
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          enabled: !state.isLoading,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 12,
          ),
          focusNode: focusNode,
          inputFormatters: inputFormatter,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.number,
          textInputAction: textInputAction,
          onFieldSubmitted: onFormFieldSubmitted,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.BORDER_YELLOW)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black54,
              ),
            ),
            errorMaxLines: 2,
            contentPadding: EdgeInsets.zero,
            hintText: hintText,
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      final nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }

    final string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
