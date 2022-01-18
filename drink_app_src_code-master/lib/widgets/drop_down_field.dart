import 'package:drink/utility/colors.dart';
import 'package:flutter/material.dart';

class DropDownField extends StatelessWidget {
  const DropDownField({
    Key key,
    @required this.focusNode,
    @required this.options,
    @required this.innerText,
    @required this.onChanged,
    @required this.validator,
    @required this.currentValue,
    this.style,
  }) : super(key: key);
  final FocusNode focusNode;
  final List<String> options;
  final String innerText;
  final Function(String) onChanged;
  final Function(String) validator;
  final String currentValue;
  final TextStyle style;

  Widget dropDownField(
    BuildContext context,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(brightness: Brightness.dark),
      child: DropdownButtonFormField(
        validator: validator,
        focusNode: focusNode,
        value: currentValue,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 12.0,
            right: 12.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.GOLDEN,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          hintText: innerText,
          hintStyle: style ??
              TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
        ),
        isExpanded: true,
        elevation: 0,
        isDense: true,
        style: TextStyle(
          color: Colors.white,
          decorationColor: Colors.white,
          fontSize: 14,
        ),
        dropdownColor: Colors.white,
        onChanged: onChanged,
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return dropDownField(
      context,
    );
  }
}
