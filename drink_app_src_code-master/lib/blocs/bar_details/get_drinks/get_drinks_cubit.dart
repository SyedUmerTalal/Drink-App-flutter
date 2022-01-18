import 'package:bloc/bloc.dart';
import 'package:drink/models/drink.dart';
import 'package:drink/models/place_details.dart';
import 'package:drink/repositories/place_repository.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'get_drinks_state.dart';

class DrinkByCategory {
  DrinkByCategory({this.id, this.drinks});

  final int id;
  final List<Drink> drinks;
}

class GetDrinksCubit extends Cubit<GetDrinksState> {
  GetDrinksCubit({this.placeRepository}) : super(GetDrinksInitial());
  final PlaceRepository placeRepository;
  List<DrinkByCategory> allDrinks = [];
  Future<void> getAllDrinks(int restaurantId, List<Bite> bites) async {
    try {
      allDrinks = [];
      emit(GetDrinkLoading());
      Future.wait(bites.map((bite) async {
        List<Drink> drinks = await placeRepository.getDrinks(
          restaurantId,
          bite.id,
        );
        return DrinkByCategory(
          drinks: drinks,
          id: bite.id,
        );
      }).toList())
          .then((drinks) => allDrinks.addAll(drinks));

      List<Drink> myDrinks = [];

      myDrinks = [
        for (List<Drink> drinkList in allDrinks
            .where((drink) => drink.id == bites[0].id)
            .map((drinkcat) => drinkcat.drinks)
            .toList())
          ...drinkList
      ];
      emit(
        GetDrinksCompleted(
          drinks: myDrinks,
          drinkCategory: bites[0],
        ),
      );
    } on PlatformException catch (e) {
      emit(GetDrinksError(e.message));
    } on AuthException {
      emit(UnAuthenticated());
    } catch (e) {
      emit(GetDrinksError(e.toString()));
    }
  }

  Future<void> getFirstCategoryFirst(int restaurantId, List<Bite> bites) async {
    try {
      allDrinks = [];
      emit(GetDrinkLoading());
      await Future.wait(bites.map((bite) async {
        List<Drink> drinks;
        try {
          drinks = await placeRepository.getDrinks(
            restaurantId,
            bite.id,
          );
        } catch (e) {
          drinks = [];
        }

        return DrinkByCategory(drinks: drinks, id: bite.id);
      }).toList())
          .then(
              (drinks) => drinks.isNotEmpty ? allDrinks.addAll(drinks) : null);
      List<Drink> myDrinks = [];

      myDrinks = [
        for (List<Drink> drinkList in allDrinks
            .where((drink) => drink.id == bites[0].id)
            .map((drinkcat) => drinkcat.drinks)
            .toList())
          ...drinkList
      ];
      emit(
        GetDrinksCompleted(
          drinkCategory: bites[0],
          drinks: myDrinks,
        ),
      );
    } on PlatformException catch (e) {
      emit(GetDrinksError(e.message));
    } on AuthException {
      emit(UnAuthenticated());
    } catch (e) {
      emit(GetDrinksError(e.toString()));
    }
  }

  void updateDrinks(Bite category) {
    List<Drink> myDrinks = [];

    myDrinks = [
      for (List<Drink> drinkList in allDrinks
          .where((drink) => drink.id == category.id)
          .map((drinkcat) => drinkcat.drinks)
          .toList())
        ...drinkList
    ];

    final GetDrinksCompleted drinksState = GetDrinksCompleted(
      drinks: myDrinks,
      drinkCategory: category,
    );
    emit(drinksState);
  }
}
