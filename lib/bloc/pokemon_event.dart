part of 'pokemon_bloc.dart';

@immutable
sealed class PokemonEvent {}

class FetchPokemons extends PokemonEvent {}

class FetchPokemonsByType extends PokemonEvent {
  final String typeName;

  FetchPokemonsByType(this.typeName);
}
