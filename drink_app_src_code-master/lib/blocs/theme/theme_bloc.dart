import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:drink/repositories/theme_repository.dart';
part 'theme_event.dart';
part 'theme_state.dart';

enum ThemeType {
  dark,
  light,
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository themeRepository;

  ThemeBloc(
    this.themeRepository,
    ThemeType initialTheme,
  ) : super(ThemeState(type: initialTheme));

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeChanged) {
      print(state.type);

      yield* _mapThemeChangedToState(
          state.type == ThemeType.dark ? ThemeType.light : ThemeType.dark);
    }
  }

  Stream<ThemeState> _mapThemeChangedToState(ThemeType type) async* {
    try {
      await themeRepository.setPreferredTheme(type);

      yield ThemeState(type: type);
    } catch (e) {
      yield ThemeChangedFailed();
    }
  }
}
