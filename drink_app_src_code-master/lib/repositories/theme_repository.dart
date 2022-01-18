import 'dart:async';

import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/utility/strings.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _storageKey = AppStrings.APP_TITLE;
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class ThemeRepository {
  ThemeType _currentType;
  ThemeType get currentType => _currentType;
  final StreamController<ThemeType> _controller = BehaviorSubject<ThemeType>();
  Stream<ThemeType> get currentTheme => _controller.stream;

  ///
  /// One-time initialization
  ///
  Future<Null> init(ThemeType type) async {
    _controller.sink.add(type);
    await setPreferredTheme(type);
    return null;
  }

  /// ----------------------------------------------------------
  /// Method that saves/restores the preferred theme
  /// ----------------------------------------------------------
  Future<ThemeType> getPreferredTheme() async {
    String type = await _getApplicationSavedInformation();
    if (type == 'dark') {
      _controller.sink.add(ThemeType.dark);
      return ThemeType.dark;
    } else {
      _controller.sink.add(ThemeType.light);
      return ThemeType.light;
    }
  }

  setPreferredTheme(ThemeType type) async {
    _controller.sink.add(type);
    return _setApplicationSavedInformation(type);
  }

  ///
  /// Application Preferences related
  ///
  /// ----------------------------------------------------------
  /// Generic routine to fetch an application preference
  /// ----------------------------------------------------------
  Future<String> _getApplicationSavedInformation() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_storageKey + "theme") ?? '';
  }

  /// ----------------------------------------------------------
  /// Generic routine to saves an application preference
  /// ----------------------------------------------------------
  Future<bool> _setApplicationSavedInformation(ThemeType type) async {
    final SharedPreferences prefs = await _prefs;
    print("SET PERS $type");
    return prefs.setString(
        _storageKey + "theme", type.toString().split('.').last);
  }
}
