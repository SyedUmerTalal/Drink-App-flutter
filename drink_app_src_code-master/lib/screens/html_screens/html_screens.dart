import 'dart:io' show Platform;
import 'package:drink/blocs/content/content_cubit.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class HTMLScreens extends StatefulWidget {
  const HTMLScreens({
    Key key,
    this.htmlPath,
    this.title,
  }) : super(key: key);
  final String htmlPath;
  final String title;

  @override
  HTMLScreensState createState() {
    return HTMLScreensState();
  }
}

class HTMLScreensState extends State<HTMLScreens> {
  @override
  void initState() {
    super.initState();
    context
        .read<ContentCubit>()
        .getContent(widget.title == AppStrings.PRIVACY_POLICY);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Container(
          decoration: themeState.type == ThemeType.light
              ? backGroundImgDecorationLight
              : backGroundImgDecoration,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
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
              elevation: themeState.type == ThemeType.light ? 0 : 16,
              title: Text(
                widget.title,
                style: TextStyle(
                  color: themeState.type == ThemeType.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
            body: BlocConsumer<ContentCubit, ContentState>(
              listener: (context, state) {
                if (state is UnAuthenticated) {
                  Navigator.of(context).pop();
                  context.read<AuthenticationRepository>().signOut();
                }
              },
              builder: (context, state) {
                if (state is Contentloaded) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Html(
                        style: {
                          'p': Style(
                              color: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                              textAlign: TextAlign.center),
                          'h1': Style(
                            color: themeState.type == ThemeType.light
                                ? Colors.black
                                : Colors.white,
                            textAlign: TextAlign.center,
                          ),
                          'h2': Style(
                              color: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                              textAlign: TextAlign.center),
                          'h3': Style(
                              color: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                              textAlign: TextAlign.center),
                          'h4': Style(
                              color: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                              textAlign: TextAlign.center),
                          'h5': Style(
                              color: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                              textAlign: TextAlign.center),
                          'h6': Style(
                              color: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                              textAlign: TextAlign.center),
                        },
                        data: state.content,
                      ),
                    ),
                  );
                } else if (state is ContentLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.CIRCLE_YELLOW),
                    ),
                  );
                } else if (state is ContentLoadFailure) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: themeState.type == ThemeType.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        );
        ;
      },
    );
  }
}
