import 'dart:io' show Platform;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:drink/blocs/credit_card/delete_creditcard/delete_creditcard_cubit.dart';
import 'package:drink/blocs/credit_card/get_creditcards/get_creditcards_cubit.dart';
import 'package:drink/blocs/credit_card/bookmark_creditcard/bookmark_creditcard_cubit.dart';
import 'package:drink/blocs/credit_card/credit_card_form/credit_card_form_bloc.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/repositories/card_repository.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/loading_dialog.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/widgets/add_card_dialog.dart';
import 'package:drink/widgets/card.dart';
import 'package:drink/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:drink/models/credit_card.dart' as cc;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({Key key, this.overlayDisabled, this.isCheckout})
      : super(key: key);
  final bool overlayDisabled;
  final bool isCheckout;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetCreditCardsCubit(CardsRepository()),
        ),
        BlocProvider<DeleteCreditcardCubit>(
          create: (context) => DeleteCreditcardCubit(CardsRepository()),
        ),
        BlocProvider<BookmarkCreditcardCubit>(
          create: (context) => BookmarkCreditcardCubit(),
        ),
      ],
      child: CreditCardsScreen(
        overlayDisabled: overlayDisabled,
      ),
    );
  }
}

class CreditCardsScreen extends StatefulWidget {
  const CreditCardsScreen({
    Key key,
    this.overlayDisabled,
  }) : super(key: key);
  final bool overlayDisabled;

  @override
  _CreditCardsScreenState createState() => _CreditCardsScreenState();
}

class _CreditCardsScreenState extends State<CreditCardsScreen> {
  cc.CreditCard _currentProvider;

  void _handleTapChanged(cc.CreditCard newValue) {
    setState(() {
      _currentProvider = newValue;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      AppNavigation.navigatorPopData(context, [_currentProvider]);
    });
  }

  void _handleDeleteTapped(cc.CreditCard model) {
    context.read<DeleteCreditcardCubit>().deleteCreditCard(model);
  }

  bool _buttonDisabled = false;

  Future<void> _cardAdded() async {
    try {
      final bool _cardAdded = await AppNavigation.showDialogGeneral(
        context,
        BlocProvider<CreditCardFormBloc>(
          create: (_) => CreditCardFormBloc(CardsRepository()),
          child: AddCreditCardDialog(),
        ),
      );
      // context.read<GetCreditCardsCubit>().getAllCreditCards();

      if (_cardAdded) {
        context.read<GetCreditCardsCubit>().getAllCreditCards();
      }

      _buttonDisabled = false;
    } catch (e) {
      _buttonDisabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetCreditCardsCubit, GetCreditCardsState>(
      listener: (context, state) {
        if (state is GetCreditCardsLoading) {
          LoadingDialog.show(context);
        } else if (state is GetCreditCardsLoaded) {
          LoadingDialog.hide(context);
        } else if (state is GetCreditCardsFailed) {
          LoadingDialog.hide(context);
          if (state.message != 'success') {
            AppNavigation.showToast(message: state.message);
          }
        } else if (state is UnAuthenticated) {
          Navigator.of(context).pop();
          context.read<AuthenticationRepository>().signOut();
        }
      },
      child: BlocListener<DeleteCreditcardCubit, DeleteCreditcardState>(
          listener: (context, state) {
        if (state.isLoaded) {
          Future.delayed(Duration.zero,
              () => context.read<GetCreditCardsCubit>().getAllCreditCards());
        }
      }, child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return Container(
              decoration: themeState.type == ThemeType.light
                  ? backGroundImgDecorationLight
                  : backGroundImgDecoration,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  elevation: themeState.type == ThemeType.light ? 0 : 16,
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: AutoSizeText(
                    AppStrings.CARDS,
                    style: TextStyle(
                      color: themeState.type == ThemeType.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: themeState.type == ThemeType.light
                              ? AppColors.CIRCLE_YELLOW
                              : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FaIcon(
                              FontAwesomeIcons.plus,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (!_buttonDisabled) {
                          _buttonDisabled = true;
                          _cardAdded();
                        }
                      },
                    )
                  ],
                  leading: IconButton(
                    icon: Platform.isAndroid
                        ? Icon(
                            Icons.arrow_back,
                            color: themeState.type == ThemeType.light
                                ? Colors.black
                                : Colors.white,
                          )
                        : Icon(
                            Icons.arrow_back_ios,
                            color: themeState.type == ThemeType.light
                                ? Colors.black
                                : Colors.white,
                          ),
                    onPressed: () {
                      AppNavigation.navigatorPop(context);
                    },
                  ),
                ),
                body: BlocBuilder<GetCreditCardsCubit, GetCreditCardsState>(
                  builder: (context, state) {
                    if (state is GetCreditCardsInitial) {
                      context.read<GetCreditCardsCubit>().getAllCreditCards();
                      return Container();
                    } else if (state is GetCreditCardsLoaded) {
                      return BlocBuilder<DeleteCreditcardCubit,
                          DeleteCreditcardState>(
                        builder: (context, creditCardState) {
                          return ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 24,
                            ),
                            itemCount: state.allCreditCards.length,
                            itemBuilder: (context, index) => IgnorePointer(
                              ignoring: creditCardState.isLoading,
                              child: CreditCard(
                                creditCardFormState: creditCardState,
                                orignalProvider: cc.CreditCard(
                                  id: state.allCreditCards[index].id,
                                  brand: state.allCreditCards[index].brand,
                                  expMonth:
                                      state.allCreditCards[index].expMonth,
                                  expYear: state.allCreditCards[index].expYear,
                                  lastFour:
                                      state.allCreditCards[index].lastFour,
                                ),
                                currentProvider: _currentProvider,
                                onChanged: _handleTapChanged,
                                onDelete: _handleDeleteTapped,
                                overlayDisabled: widget.overlayDisabled,
                              ),
                            ),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 16,
                            ),
                          );
                        },
                      );
                    } else if (state is GetCreditCardsFailed) {
                      return EmptyListWidget(
                        title: AppStrings.NO_CARD,
                        subTitle: AppStrings.NO_CARD_PUNCHLINE,
                        titleTextStyle: Theme.of(context)
                            .typography
                            .dense
                            .headline5
                            .copyWith(
                              color: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                        image: AssetPaths.SAD_IMAGE,
                        subtitleTextStyle: Theme.of(context)
                            .typography
                            .dense
                            .bodyText2
                            .copyWith(
                              color: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                        themeType: themeState.type,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ));
        },
      )),
    );
  }
}
