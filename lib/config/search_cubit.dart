import 'package:bloc/bloc.dart';

class SearchCubit extends Cubit<String> {
  SearchCubit() : super(''); // Initial state is an empty string

  void updateSearchQuery(String query) {
    emit(query);
  }
}
