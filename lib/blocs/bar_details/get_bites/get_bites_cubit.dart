import 'package:bloc/bloc.dart';
import 'package:drink/blocs/bar_details/get_drinks/get_drinks_cubit.dart';
import 'package:drink/models/drink.dart';
import 'package:drink/models/place_details.dart';
import 'package:drink/repositories/place_repository.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'get_bites_state.dart';

class GetBitesCubit extends Cubit<GetBitesState> {
  GetBitesCubit({this.placeRepository}) : super(GetBitesInitial());
  final PlaceRepository placeRepository;
  List<DrinkByCategory> allBites = [];
  Future<void> getAllBites(int restaurantId, List<Bite> bites) async {
    try {
      allBites = [];
      emit(GetBitesLoading());

      await Future.wait(bites.map((bite) async {
        try {
          List<Drink> bites = await placeRepository.getBites(
            restaurantId,
            bite.id,
          );
          return DrinkByCategory(
            drinks: bites,
            id: bite.id,
          );
        } on PlatformException {
          return DrinkByCategory(
            drinks: [],
            id: bite.id,
          );
        } catch (e) {
          return DrinkByCategory(
            drinks: [],
            id: bite.id,
          );
        }
      }).toList())
          .then((drinks) => allBites.addAll(drinks));
      List<Drink> myBites = [];

      myBites = [
        if (allBites.isNotEmpty)
          for (List<Drink> biteList in allBites
              .where((bite) => bite.id == bites[0].id)
              .map((bitecat) => bitecat.drinks)
              .toList())
            ...biteList
      ];

      emit(
        GetBitesCompleted(
          bites: myBites,
          biteCategory: bites[0],
        ),
      );
    } on PlatformException catch (e) {
      emit(GetBitesError(e.message));
    } on AuthException {
      emit(UnAuthenticated());
    } catch (e) {
      emit(GetBitesError(e.toString()));
    }
  }

  void updateBite(Bite biteCategory) {
    List<Drink> myBites = [];
    myBites = [
      for (List<Drink> biteList in allBites
          .where((bite) => bite.id == biteCategory.id)
          .map((bitecat) => bitecat.drinks)
          .toList())
        ...biteList
    ];
    emit(GetBitesCompleted(
      bites: myBites,
      biteCategory: biteCategory,
    ));
  }
}
