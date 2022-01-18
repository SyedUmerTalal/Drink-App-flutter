part of 'get_bites_cubit.dart';

abstract class GetBitesState extends Equatable {
  const GetBitesState();

  @override
  List<Object> get props => [];
}

class GetBitesInitial extends GetBitesState {}

// class GetBitesCompleted extends GetBitesState {
//   const GetBitesCompleted(this.allBites);
//   final List<Drink> allBites;
// }

class GetBitesCompleted extends GetBitesState {
  const GetBitesCompleted({
    this.bites,
    this.biteCategory,
  });

  final List<Drink> bites;
  final Bite biteCategory;

  GetBitesCompleted copyWith({List<Drink> bites, Bite biteCategory}) {
    return GetBitesCompleted(
      bites: bites ?? this.bites,
      biteCategory: biteCategory ?? this.biteCategory,
    );
  }

  @override
  List<Object> get props => [
        bites,
        biteCategory,
      ];
}

class UnAuthenticated extends GetBitesState {}

class GetBitesError extends GetBitesState {
  const GetBitesError(this.message);
  final String message;
}

class GetBitesLoading extends GetBitesState {}
