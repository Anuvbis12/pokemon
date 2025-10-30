import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/services/pokemon_service.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonService _pokemonService = PokemonService();

  PokemonBloc() : super(PokemonInitial()) {
    on<FetchPokemons>((event, emit) async {
      emit(PokemonLoading());
      try {
        final pokemonList = await _pokemonService.fetchPokemonList();
        emit(PokemonLoaded(pokemonList));
      } catch (e) {
        emit(PokemonError(e.toString()));
      }
    });

    on<FetchPokemonsByType>((event, emit) async {
      emit(PokemonLoading());
      try {
        final response = await Dio().get('https://pokeapi.co/api/v2/type/${event.typeName}');
        final pokemonList = (response.data['pokemon'] as List)
            .map((p) => Pokemon.fromJson(p['pokemon']))
            .toList();
        emit(PokemonLoaded(pokemonList));
      } catch (e) {
        emit(PokemonError('Failed to load Pokémon by type: ${e.toString()}'));
      }
    });
  }
}
