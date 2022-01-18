import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DOBInputField extends StatefulWidget {
  const DOBInputField({
    Key key,
    this.dateTimeFocus,
    this.onFieldSubmitted,
    this.onChanged,
    this.validator,
    this.onShowPicker,
    this.controller,
    this.hintText,
    this.dateFormat,
    this.enabled,
    this.padding,
  }) : super(key: key);
  final String dateFormat, hintText;
  final FocusNode dateTimeFocus;
  final Function(DateTime) onFieldSubmitted, validator, onChanged;
  final bool enabled;
  final EdgeInsetsGeometry padding;

  final Future<DateTime> Function(BuildContext, DateTime) onShowPicker;
  final TextEditingController controller;

  @override
  _DOBInputFieldState createState() => _DOBInputFieldState();
}

class _DOBInputFieldState extends State<DOBInputField> {
  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      controller: widget.controller,
      format: DateFormat(widget.dateFormat ?? AppStrings.DATE_FORMAT_DOB),
      onShowPicker: widget.onShowPicker,
      validator: widget.validator,
      onChanged: widget.onChanged,
      resetIcon: null,
      readOnly: true,
      enabled: widget.enabled ?? true,
      focusNode: widget.dateTimeFocus,
      style: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        hintText: widget.hintText ?? AppStrings.DATEOFBIRTH,
        hintStyle: TextStyle(fontSize: 14, color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.GOLDEN,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.BORDER_YELLOW,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: widget.padding ??
            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
