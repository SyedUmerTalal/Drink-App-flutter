import 'package:drink/models/credit_card.dart' as cc;
import 'package:drink/widgets/custom_height_dropdown.dart' as dropdown;
import 'package:flutter/material.dart';

class DropDownCardField extends StatelessWidget {
  const DropDownCardField({
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
  final List<cc.CreditCard> options;
  final String innerText;
  final Function(cc.CreditCard) onChanged;
  final Function(cc.CreditCard) validator;
  final cc.CreditCard currentValue;
  final TextStyle style;

  Widget dropDownField(
    BuildContext context,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(brightness: Brightness.dark),
      child: DropdownButtonHideUnderline(
        child: dropdown.DropdownButton<cc.CreditCard>(
          focusNode: focusNode,
          value: currentValue,
          itemHeight: 300,
          selectedItemBuilder: (context) => options
              .map<dropdown.DropdownMenuItem<cc.CreditCard>>(
                  (cc.CreditCard value) {
            return dropdown.DropdownMenuItem<cc.CreditCard>(
              value: value,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                // child: CreditCard(
                //   cardName: value.cardName,
                //   cardNumber: value.cardNumber,
                //   expeiry: value.expeiry,
                // ),
              ),
            );
          }).toList(),
          // decoration: InputDecoration(
          //   // contentPadding: EdgeInsets.only(
          //   //   left: 12.0,
          //   //   right: 12.0,
          //   // ),

          //   enabledBorder: OutlineInputBorder(
          //     borderSide: BorderSide(
          //       color: AppColors.GOLDEN,
          //     ),
          //     borderRadius: BorderRadius.all(
          //       Radius.circular(12.0),
          //     ),
          //   ),
          //   border: OutlineInputBorder(
          //     borderRadius: BorderRadius.all(
          //       Radius.circular(12.0),
          //     ),
          //   ),
          //   hintText: innerText,
          //   hintStyle: style ??
          //       TextStyle(
          //         color: Colors.white,
          //         fontSize: 14,
          //       ),
          // ),
          isExpanded: true,
          elevation: 0,
          isDense: true,
          style: TextStyle(
            color: Colors.white,
            decorationColor: Colors.white,
            fontSize: 14,
          ),
          dropdownColor: Colors.transparent,
          onChanged: onChanged,
          items: options.map<dropdown.DropdownMenuItem<cc.CreditCard>>(
              (cc.CreditCard value) {
            return dropdown.DropdownMenuItem<cc.CreditCard>(
              value: value,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                // child: CreditCard(
                // orignalProvider: cc.CreditCard(cardName: value.cardName,cardNumber: value.cardNumber),
                // ),
              ),
            );
          }).toList(),
        ),
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
