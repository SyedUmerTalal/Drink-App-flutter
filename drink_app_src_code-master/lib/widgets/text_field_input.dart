import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextFieldInput extends StatefulWidget {
  const TextFieldInput({
    Key key,
    @required this.hintText,
    @required this.inputType,
    @required this.inputAction,
    @required this.focusNode,
    @required this.formFieldSubmitted,
    @required this.validator,
    @required this.themeType,
    this.inputFormatters,
    this.onChanged,
    this.isPassword = false,
    this.hintStyle,
    this.textStyle,
    this.initialValue,
    this.readOnly,
    this.textEditingController,
  }) : super(key: key);

  final String hintText, initialValue;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final FocusNode focusNode;
  final Function(String) formFieldSubmitted, validator, onChanged;
  final bool isPassword;
  final List<TextInputFormatter> inputFormatters;
  final TextStyle hintStyle, textStyle;
  final TextEditingController textEditingController;
  final bool readOnly;
  final ThemeType themeType;

  @override
  _TextFieldInputState createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool visible = true;

  Widget _showInput() {
    return TextFormField(
      controller: widget.textEditingController,
      //initialValue: widget.initialValue ?? '',
      textInputAction: widget.inputAction,

      keyboardType: widget.inputType,
      readOnly: widget.readOnly ?? false,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.formFieldSubmitted,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: widget.isPassword ? visible : false,
      style: widget.textStyle ??
          TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
      onChanged: widget.onChanged ?? (value) {},
      inputFormatters: widget.inputFormatters ?? [],
      cursorColor:widget.themeType==ThemeType.dark? Colors.white:Colors.black,
      decoration: InputDecoration(
        filled: widget.themeType == ThemeType.light ? true : false,
        fillColor: widget.themeType == ThemeType.light
            ? Colors.white
            : Colors.transparent,
        errorMaxLines: 3,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        suffixIcon: Visibility(
          visible: widget.isPassword,
          child: IconButton(
            icon: visible
                ? Icon(
                    FontAwesomeIcons.eye,
                    color: widget.themeType == ThemeType.light
                        ? Colors.black
                        : Colors.white,
                    size: 14,
                  )
                : Icon(
                    FontAwesomeIcons.eyeSlash,
                    color: widget.themeType == ThemeType.light
                        ? Colors.black
                        : Colors.white,
                    size: 14,
                  ),
            onPressed: () {
              setState(() {
                visible = !visible;
              });
            },
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.GOLDEN,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        hintText: widget.hintText,
        hintStyle: widget.hintStyle ??
            TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.themeType == ThemeType.light
        ? Material(
            elevation: 20.0,
            shadowColor: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.transparent,
            child: _showInput())
        : _showInput();

    // Container(
  }
}
