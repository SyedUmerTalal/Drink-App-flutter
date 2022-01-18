import 'package:auto_size_text/auto_size_text.dart';
import 'package:drink/blocs/cart/cart_cubit.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/models/cart_model.dart';
import 'package:drink/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartListTile extends StatefulWidget {
  const CartListTile({
    Key key,
    @required this.cartModel,
    @required this.themeType,
  }) : super(key: key);
  final CartModel cartModel;
  final ThemeType themeType;

  @override
  _CartListTileState createState() => _CartListTileState();
}

class _CartListTileState extends State<CartListTile> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 20,
          child: Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.CIRCLE_YELLOW,
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    widget.cartModel.drink.picture,
                  ),
                  fit: BoxFit.cover,
                )),
          ),
        ),
        Spacer(
          flex: 2,
        ),
        Expanded(
          flex: 35,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                widget.cartModel.drink.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.themeType == ThemeType.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              AutoSizeText(
                widget.cartModel.drink.category,
                minFontSize: 12,
                style: TextStyle(
                  color: widget.themeType == ThemeType.light
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              AutoSizeText(
                widget.cartModel.drink.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                minFontSize: 10,
                style: TextStyle(
                  color: widget.themeType == ThemeType.light
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        // Spacer(
        //   flex: 3,
        // ),
        Expanded(
          flex: 20,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '\$ ${widget.cartModel.drink.price.toString()}',
                style: TextStyle(
                  color: AppColors.TEXT_YELLOW,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  minusButton(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '${widget.cartModel.qty}',
                      style: TextStyle(
                        color: widget.themeType == ThemeType.light
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  plusButton(),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  InkWell plusButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            color: AppColors.TEXT_YELLOW,
            borderRadius: BorderRadius.circular(5.0)),
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onTap: () {
        context.read<CartCubit>().addProduct(widget.cartModel.drink);
      },
    );
  }

  InkWell minusButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            color: AppColors.TEXT_YELLOW,
            borderRadius: BorderRadius.circular(5.0)),
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FaIcon(
              FontAwesomeIcons.minus,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onTap: () {
        context.read<CartCubit>().removeProduct(widget.cartModel.drink);
      },
    );
  }
}
