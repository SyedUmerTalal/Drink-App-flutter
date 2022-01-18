part of 'update_circle_cubit.dart';

class UpdateCircleState extends Equatable {
  const UpdateCircleState({
    this.center,
    this.radius,
  });
  final LatLng center;
  final double radius;

  UpdateCircleState copyWith({
    LatLng center,
    double radius,
  }) {
    return UpdateCircleState(
      center: center ?? this.center,
      radius: radius ?? this.radius,
    );
  }

  @override
  List<Object> get props => [
        center,
        radius,
      ];
}
