import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/bloc/pokemon_bloc.dart';
import 'package:pokemon/config/search_cubit.dart';
import 'package:pokemon/cubit/filter_cubit.dart';
import 'package:pokemon/cubit/type_cubit.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/screens/pokemon_detail_screen.dart';
import 'package:pokemon/widgets/pokemon_card.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final Map<String, Color> _typeColorMap = {
    'grass': Colors.green.shade300,
    'fire': Colors.red.shade300,
    'water': Colors.blue.shade300,
    'poison': Colors.purple.shade300,
    'electric': Colors.amber.shade300,
    'rock': Colors.grey.shade600,
    'ground': Colors.brown.shade300,
    'bug': Colors.lightGreen.shade300,
    'psychic': Colors.pink.shade300,
    'fighting': Colors.orange.shade300,
    'ghost': Colors.deepPurple.shade300,
    'ice': Colors.cyanAccent.shade400,
    'dragon': Colors.indigo.shade300,
    'fairy': Colors.pinkAccent.shade100,
    'normal': Colors.blueGrey.shade300,
    'default': Colors.grey.shade300,
  };

  Color _getColorForPokemon(Pokemon pokemon) {
    if (pokemon.types != null && pokemon.types!.isNotEmpty) {
      return _typeColorMap[pokemon.types![0]] ?? _typeColorMap['default']!;
    }
    return _typeColorMap['default']!;
  }

  @override
  void initState() {
    super.initState();
    context.read<PokemonBloc>().add(FetchPokemons());
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: BlocProvider.of<TypeCubit>(context),
          child: BlocBuilder<TypeCubit, List<Map<String, dynamic>>>(
            builder: (context, types) {
              return BlocBuilder<FilterCubit, String?>(
                builder: (context, selectedType) {
                  return ListView.builder(
                    itemCount: types.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ListTile(
                          title: const Text('All'),
                          trailing: selectedType == null ? const Icon(Icons.check, color: Colors.red) : null,
                          onTap: () {
                            context.read<FilterCubit>().selectType(null);
                            Navigator.pop(context);
                          },
                        );
                      }
                      final type = types[index - 1];
                      final typeName = type['name'] as String;
                      return ListTile(
                        title: Text(typeName.capitalize()),
                        trailing: selectedType == typeName ? const Icon(Icons.check, color: Colors.red) : null,
                        onTap: () {
                          context.read<FilterCubit>().selectType(typeName);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FilterCubit, String?>(
      listener: (context, selectedType) {
        if (selectedType == null) {
          context.read<PokemonBloc>().add(FetchPokemons());
        } else {
          context.read<PokemonBloc>().add(FetchPokemonsByType(selectedType));
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Pokédex'),
          centerTitle: true,
          elevation: 4.0,
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterBottomSheet(context),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFDC0A2D), Color(0xFFF0F0F0)],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 8.0),
                child: TextField(
                  onChanged: (query) {
                    context.read<SearchCubit>().updateSearchQuery(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Pokémon',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withAlpha(230),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<PokemonBloc, PokemonState>(
                  builder: (context, pokemonState) {
                    if (pokemonState is PokemonLoading) {
                      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
                    } else if (pokemonState is PokemonError) {
                      return Center(child: Text(pokemonState.message, style: const TextStyle(color: Colors.white)));
                    } else if (pokemonState is PokemonLoaded) {
                      final allPokemons = pokemonState.pokemons;

                      return BlocBuilder<SearchCubit, String>(
                        builder: (context, searchQuery) {
                          final filteredPokemons = allPokemons.where((pokemon) {
                            return pokemon.name.toLowerCase().contains(searchQuery.toLowerCase());
                          }).toList();

                          return GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 200,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: filteredPokemons.length,
                            itemBuilder: (context, index) {
                              final pokemon = filteredPokemons[index];
                              return PokemonCard(
                                pokemon: pokemon,
                                color: _getColorForPokemon(pokemon),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PokemonDetailScreen(pokemon: pokemon),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
