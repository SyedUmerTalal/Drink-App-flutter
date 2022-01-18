import 'package:bloc/bloc.dart';
import 'package:drink/models/tables.dart';
import 'package:drink/repositories/table_repository.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'get_tables_state.dart';

class GetTablesCubit extends Cubit<GetTablesState> {
  GetTablesCubit(
    this.tableRepository,
  ) : super(GetTablesInitial());
  final TableRepository tableRepository;

  Future<void> getAllTables(int restaurantId, int categoryId) async {
    try {
      emit(GetTablesLoading());

      final List<Tables> tables = await tableRepository.getTables(restaurantId);

      emit(GetTablesCompleted(tables));
    } on PlatformException catch (e) {
      emit(GetTablesError(e.message));
    } on AuthException {
      emit(UnAuthenticated());
    } catch (e) {
      emit(GetTablesError(e.toString()));
    }
  }
}
