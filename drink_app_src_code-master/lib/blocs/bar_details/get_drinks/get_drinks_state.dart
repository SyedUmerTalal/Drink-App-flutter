part of 'get_drinks_cubit.dart';

abstract class GetDrinksState extends Equatable {
  const GetDrinksState();

  @override
  List<Object> get props => [];
}

class GetDrinksInitial extends GetDrinksState {}

class GetDrinksCompleted extends GetDrinksState {
   GetDrinksCompleted({
    this.drinks,
    this.drinkCategory,
  });

  final List<Drink> drinks;
  final Bite drinkCategory;
  GetDrinksCompleted copyWith({Bite drinkCategory, List<Drink> drinks}) {
    return GetDrinksCompleted(
      drinks: drinks ?? this.drinks,
      drinkCategory: drinkCategory ?? this.drinkCategory,
    );
  }

  @override
  List<Object> get props => [drinks, drinkCategory];
}

class GetDrinksError extends GetDrinksState {
  const GetDrinksError(this.message);

  final String message;
}

class GetDrinkLoading extends GetDrinksState {}

class UnAuthenticated extends GetDrinksState {}
