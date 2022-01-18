part of 'get_tables_cubit.dart';

abstract class GetTablesState extends Equatable {
  const GetTablesState();

  @override
  List<Object> get props => [];
}

class GetTablesInitial extends GetTablesState {}

class GetTablesCompleted extends GetTablesState {
  const GetTablesCompleted(this.allTables);

  final List<Tables> allTables;
}

class GetTablesError extends GetTablesState {
  const GetTablesError(this.message);

  final String message;
}

class GetTablesLoading extends GetTablesState {}

class UnAuthenticated extends GetTablesState {}
