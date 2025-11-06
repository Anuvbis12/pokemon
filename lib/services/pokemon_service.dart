import 'package:dio/dio.dart';
import 'package:pokemon/models/pokemon.dart';

class PokemonService {
  final Dio _dio = Dio();

  Future<List<Pokemon>> fetchPokemonList() async {
    try {
      final response = await _dio.get('https://pokeapi.co/api/v2/pokemon?limit=350');
      final List<dynamic> results = response.data['results'];
      final pokemonList = results.map((json) => Pokemon.fromJson(json)).toList();
      return pokemonList;
    } catch (e) {
      throw Exception('Failed to load Pokémon list');
    }
  }

  Future<List<Pokemon>> fetchDetailsForList(List<Pokemon> pokemons) async {
    try {
      final pokemonFutures = pokemons.map((pokemon) async {
        if (pokemon.types == null) {
          final detailResponse = await _dio.get(pokemon.url);
          final data = detailResponse.data;
          pokemon.types = (data['types'] as List<dynamic>)
              .map((typeInfo) => typeInfo['type']['name'] as String)
              .toList();
        }
        return pokemon;
      }).toList();

      return await Future.wait(pokemonFutures);
    } catch (e) {
      print('Failed to fetch some details: $e');
      return pokemons;
    }
  }

  Future<Pokemon> fetchPokemonByName(String name) async {
    try {
      final response = await _dio.get('https://pokeapi.co/api/v2/pokemon/$name');
      final pokemon = Pokemon.fromDetailJson(response.data);
      return fetchPokemonDetails(pokemon); // Reuse existing detail fetching logic
    } catch (e) {
      throw Exception('Failed to load Pokémon by name');
    }
  }

  Future<Pokemon> fetchPokemonDetails(Pokemon pokemon) async {
    try {
      final response = await _dio.get(pokemon.url);
      final data = response.data;
      pokemon.types = (data['types'] as List<dynamic>)
          .map((typeInfo) => typeInfo['type']['name'] as String)
          .toList();
      pokemon.stats = (data['stats'] as List<dynamic>)
          .map((statInfo) => {
                'name': statInfo['stat']['name'],
                'base_stat': statInfo['base_stat'],
              })
          .toList();
      pokemon.abilities = (data['abilities'] as List<dynamic>)
          .map((abilityInfo) => abilityInfo['ability']['name'] as String)
          .toList();
      pokemon.height = data['height'];
      pokemon.weight = data['weight'];

      final speciesResponse = await _dio.get('https://pokeapi.co/api/v2/pokemon-species/${pokemon.id}');
      if (speciesResponse.data['evolution_chain'] != null) {
        final evolutionChainUrl = speciesResponse.data['evolution_chain']['url'];
        final evolutionChainResponse = await _dio.get(evolutionChainUrl);
        final evolutionChainData = evolutionChainResponse.data['chain'];

        final List<Map<String, dynamic>> evolutionDetails = [];
        var currentEvolution = evolutionChainData;
        while (currentEvolution != null) {
          final speciesUrl = currentEvolution['species']['url'] as String;
          final segments = speciesUrl.split('/');
          final id = int.parse(segments[segments.length - 2]);
          evolutionDetails.add({
            'name': currentEvolution['species']['name'],
            'id': id,
          });
          if (currentEvolution['evolves_to'].isNotEmpty) {
            currentEvolution = currentEvolution['evolves_to'][0];
          } else {
            currentEvolution = null;
          }
        }
        pokemon.evolutions = evolutionDetails;
      }

      return pokemon;
    } catch (e) {
      throw Exception('Failed to load Pokémon details');
    }
  }
}
