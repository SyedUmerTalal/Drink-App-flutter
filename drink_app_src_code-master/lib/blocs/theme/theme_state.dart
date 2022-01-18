part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeType type;

  ThemeState({this.type});

  @override
  List<Object> get props => [type];

  @override
  String toString() {
    return 'the type is $type';
  }
}

class ThemeChangedFailed extends ThemeState {
  @override
  List<Object> get props => [];
}
