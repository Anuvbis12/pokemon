import 'package:bloc/bloc.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/services/pokemon_service.dart';

abstract class PokemonDetailState {}

class PokemonDetailInitial extends PokemonDetailState {}

class PokemonDetailLoading extends PokemonDetailState {}

class PokemonDetailLoaded extends PokemonDetailState {
  final Pokemon pokemon;
  PokemonDetailLoaded(this.pokemon);
}

class PokemonDetailError extends PokemonDetailState {
  final String message;
  PokemonDetailError(this.message);
}

class PokemonDetailCubit extends Cubit<PokemonDetailState> {
  final PokemonService _pokemonService = PokemonService();

  PokemonDetailCubit() : super(PokemonDetailInitial());

  Future<void> fetchPokemonDetails(Pokemon pokemon) async {
    emit(PokemonDetailLoading());
    try {
      final details = await _pokemonService.fetchPokemonDetails(pokemon);
      emit(PokemonDetailLoaded(details));
    } catch (e) {
      emit(PokemonDetailError(e.toString()));
    }
  }

  Future<void> fetchPokemonByName(String name) async {
    emit(PokemonDetailLoading());
    try {
      final details = await _pokemonService.fetchPokemonByName(name);
      emit(PokemonDetailLoaded(details));
    } catch (e) {
      emit(PokemonDetailError(e.toString()));
    }
  }
}
