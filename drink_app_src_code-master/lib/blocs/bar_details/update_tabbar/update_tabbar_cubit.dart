import 'package:bloc/bloc.dart';

class UpdateTabbarCubit extends Cubit<int> {
  UpdateTabbarCubit() : super(0);

  void updateTabbar(int updatedValue) {
    emit(updatedValue);
  }
}
