import 'package:auto_size_text/auto_size_text.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/strings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drink/blocs/credit_card/delete_creditcard/delete_creditcard_cubit.dart';
import 'package:drink/blocs/credit_card/bookmark_creditcard/bookmark_creditcard_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:drink/models/credit_card.dart' as cc;
import 'package:drink/widgets/credit_card_background_clipper.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({
    this.orignalProvider,
    this.currentProvider,
    this.onChanged,
    this.onDelete,
    this.overlayDisabled = false,
    this.creditCardFormState,
    this.isOrdertailsScreen = false,
    Key key,
  }) : super(key: key);
  final cc.CreditCard orignalProvider;
  final cc.CreditCard currentProvider;
  final ValueChanged<cc.CreditCard> onChanged;
  final ValueChanged<cc.CreditCard> onDelete;
  final DeleteCreditcardState creditCardFormState;
  final bool isOrdertailsScreen;

  final bool overlayDisabled;

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  bool overlayVisible = false;
  void _handleTap() {
    widget.onChanged(widget.orignalProvider);
  }

  @override
  void initState() {
    super.initState();
    context.read<BookmarkCreditcardCubit>().getBookMarkedCreditCard();
  }

  @override
  Widget build(BuildContext context) {
    final bool selected = (widget.orignalProvider == widget.currentProvider) &&
        widget.overlayDisabled;

    return InkWell(
      onTap: widget.overlayDisabled ? _handleTap : null,
      onLongPress: widget.overlayDisabled || widget.isOrdertailsScreen
          ? null
          : () {
              setState(() {
                overlayVisible = !overlayVisible;
              });
            },
      borderRadius: BorderRadius.circular(8),
      child: BlocBuilder<BookmarkCreditcardCubit, BookmarkCreditcardState>(
        builder: (context, state) {
          return Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: (selected ||
                          (state?.creditCard == widget.orignalProvider))&& !widget.isOrdertailsScreen
                      ? AppColors.LIGHT_GREEN
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Stack(
              clipBehavior:
                  (selected || (state?.creditCard == widget.orignalProvider))
                      ? Clip.none
                      : Clip.hardEdge,
              children: [
                creditCardContainerWithDetails(),
                creditCardImage(),
                Visibility(
                  visible: overlayVisible && !widget.overlayDisabled &&  !widget.isOrdertailsScreen,
                  child: onTapOverlayContainer(state),
                ),
                Visibility(
                  visible: (selected ||
                      (state?.creditCard == widget.orignalProvider) &&
                          !widget.isOrdertailsScreen),
                  child: Positioned(
                    top: -10,
                    right: -10,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.LIGHT_GREEN,
                      ),
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Container creditCardContainerWithDetails() {
    return Container(
      constraints: BoxConstraints.expand(
        height: 72,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.CREDITCARD_BACKGROUND_COLOR,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              '**** **** **** ${widget.orignalProvider.lastFour.toString()}' ??
                  AppStrings.DUMMY_CARD_NO,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            AutoSizeText(
              DateFormat(AppStrings.DATE_FORMAT_EXPEIRY)
                      .format(DateTime(widget.orignalProvider.expYear,
                          widget.orignalProvider.expMonth))
                      .toString() ??
                  AppStrings.DUMMY_DATE,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned creditCardImage() {
    return Positioned(
      right: -20,
      child: ClipPath(
        clipper: CreditCardBgClipper(),
        child: Image.asset(
          AssetPaths.CARD_ICON,
          color: Colors.white.withOpacity(0.6),
          height: 104,
        ),
      ),
    );
  }

  InkWell onTapOverlayContainer(BookmarkCreditcardState state) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        setState(() {
          overlayVisible = !overlayVisible;
        });
      },
      child: Container(
        constraints: BoxConstraints.expand(
          height: 72,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black.withOpacity(0.4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              checkCardButton(),
              SizedBox(width: 16),
              deleteCardButton(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget checkCardButton() {
    return BlocBuilder<BookmarkCreditcardCubit, BookmarkCreditcardState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            if (state?.creditCard != widget.orignalProvider) {
              context
                  .read<BookmarkCreditcardCubit>()
                  .bookMarkCreditCard(widget.orignalProvider);
              overlayVisible = !overlayVisible;

              setState(() {});
            } else {
              context
                  .read<BookmarkCreditcardCubit>()
                  .removebookMarkCreditCard(widget.orignalProvider);

              overlayVisible = !overlayVisible;

              setState(() {});
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FaIcon(
                  FontAwesomeIcons.check,
                  color: AppColors.BORDER_YELLOW,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  InkWell deleteCardButton(BookmarkCreditcardState state) {
    return InkWell(
      onTap: () {
        widget.onDelete(widget.orignalProvider);
        if (state.creditCard == widget.orignalProvider) {
          context
              .read<BookmarkCreditcardCubit>()
              .removebookMarkCreditCard(widget.orignalProvider);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.creditCardFormState?.isLoading ?? false
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.CIRCLE_YELLOW),
                )
              : Image.asset(
                  AssetPaths.DELETE_ICON,
                  color: AppColors.BORDER_YELLOW,
                  width: 24,
                  height: 24,
                ),
        ),
      ),
    );
  }
}
