import 'package:bloc/bloc.dart';

class FilterCubit extends Cubit<String?> {
  FilterCubit() : super(null); // null means no filter applied

  void selectType(String? typeName) {
    emit(typeName);
  }
}
