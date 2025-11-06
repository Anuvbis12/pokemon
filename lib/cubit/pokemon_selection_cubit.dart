import 'package:bloc/bloc.dart';
import 'package:pokemon/models/pokemon.dart';

class PokemonSelectionCubit extends Cubit<Pokemon?> {
  PokemonSelectionCubit() : super(null); // Initially, no pokemon is selected

  void selectPokemon(Pokemon? pokemon) {
    emit(pokemon);
  }
}
