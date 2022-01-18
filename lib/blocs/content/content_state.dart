part of 'content_cubit.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

class Contentloaded extends ContentState {
  const Contentloaded(this.content);

  final dynamic content;
}

class ContentLoadFailure extends ContentState {
  const ContentLoadFailure(this.message);

  final String message;
}

class UnAuthenticated extends ContentState {}
