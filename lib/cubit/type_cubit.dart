import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

class TypeCubit extends Cubit<List<Map<String, dynamic>>> {
  TypeCubit() : super([]);

  Future<void> fetchTypes() async {
    try {
      final response = await Dio().get('https://pokeapi.co/api/v2/type/');
      emit(List<Map<String, dynamic>>.from(response.data['results']));
    } catch (e) {
      print('Error fetching types: $e');
      emit([]); // Emit empty list on error
    }
  }
}
