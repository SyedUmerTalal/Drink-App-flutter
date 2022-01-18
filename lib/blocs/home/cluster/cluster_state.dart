part of 'cluster_cubit.dart';

class ClusterState extends Equatable {
  const ClusterState({
    this.placeDetailsResponse,
    this.message,
    this.requested,
    this.isUnAuthenticated,
  });
  factory ClusterState.initial() {
    return ClusterState(
      placeDetailsResponse: const [],
      message: '',
      requested: false,
    );
  }
  final List<DPlaceDetails> placeDetailsResponse;
  final String message;
  final bool isUnAuthenticated;
  final bool requested;

  ClusterState copyWith({
    List<DPlaceDetails> placeDetailsResponse,
    String message,
    bool requested,
    bool isUnAuthenticated,
  }) {
    return ClusterState(
      message: message ?? this.message,
      placeDetailsResponse: placeDetailsResponse ?? this.placeDetailsResponse,
      requested: requested ?? this.requested,
      isUnAuthenticated: isUnAuthenticated ?? this.isUnAuthenticated,
    );
  }

  @override
  String toString() {
    return '''Cluster State {
      placeDetailsResponse: ${placeDetailsResponse.length},
      message: $message,
      requested: $requested,

    }''';
  }

  @override
  List<Object> get props => [
        placeDetailsResponse,
        message,
        requested,
      ];
}
