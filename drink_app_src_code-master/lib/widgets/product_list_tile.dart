import 'package:drink/models/order.dart';
import 'package:drink/utility/colors.dart';
import 'package:flutter/material.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({Key key, @required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.name.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Text(
                item.qty.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Text(
                '\$ ' + item.price.toString(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.TEXT_YELLOW),
              ),
            ],
          ),
          Divider(
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
