part of 'pokemon_bloc.dart';

@immutable
sealed class PokemonState {}

final class PokemonInitial extends PokemonState {}

final class PokemonLoading extends PokemonState {}

final class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemons; // Changed from List<dynamic> to List<Pokemon>

  PokemonLoaded(this.pokemons);
}

final class PokemonError extends PokemonState {
  final String message;

  PokemonError(this.message);
}
