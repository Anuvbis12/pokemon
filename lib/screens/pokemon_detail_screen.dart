import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/cubit/pokemon_detail_cubit.dart';
import 'package:pokemon/models/pokemon.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon? pokemon;
  final String? pokemonName;

  const PokemonDetailScreen({super.key, this.pokemon, this.pokemonName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = PokemonDetailCubit();
        if (pokemon != null) {
          cubit.fetchPokemonDetails(pokemon!);
        } else if (pokemonName != null) {
          cubit.fetchPokemonByName(pokemonName!);
        }
        return cubit;
      },
      child: Scaffold(
        // The AppBar title can now be driven by the state
        body: BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
          builder: (context, state) {
            if (state is PokemonDetailLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Text(state.pokemon.name.toUpperCase()),
                    centerTitle: true,
                    elevation: 0,
                  ),
                  const SliverToBoxAdapter(
                    child: PokemonDetailView(),
                  )
                ],
              );
            } else if (state is PokemonDetailLoading || state is PokemonDetailInitial) {
              return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
            } else if (state is PokemonDetailError) {
              return Scaffold(appBar: AppBar(), body: Center(child: Text(state.message)));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class PokemonDetailView extends StatelessWidget {
  const PokemonDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
      builder: (context, state) {
        if (state is PokemonDetailLoaded) {
          final pokemonDetails = state.pokemon;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: pokemonDetails.id,
                  child: Image.network(
                    pokemonDetails.imageUrl,
                    height: 250,
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDetailCard(
                  title: 'Info Dasar',
                  children: [
                    _buildDetailRow('Name', pokemonDetails.name.toUpperCase()),
                    _buildDetailRow('Height', '${pokemonDetails.height! / 10} m'),
                    _buildDetailRow('Weight', '${pokemonDetails.weight! / 10} kg'),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDetailCard(
                  title: 'Tipe',
                  children: pokemonDetails.types!
                      .map((type) => _buildDetailRow('', type.toUpperCase()))
                      .toList(),
                ),
                const SizedBox(height: 20),
                if (pokemonDetails.evolutions != null &&
                    pokemonDetails.evolutions!.isNotEmpty)
                  _buildEvolutionCard(pokemonDetails),
                const SizedBox(height: 20),
                _buildDetailCard(
                  title: 'Statistik',
                  children: pokemonDetails.stats!
                      .map((stat) => _buildDetailRow(
                          stat['name'].toString().toUpperCase(),
                          stat['base_stat'].toString()))
                      .toList(),
                ),
                const SizedBox(height: 20),
                _buildDetailCard(
                  title: 'Kemampuan',
                  children: pokemonDetails.abilities!
                      .map((ability) => _buildDetailRow('', ability.toUpperCase()))
                      .toList(),
                ),
              ],
            ),
          );
        }
        // This part is handled by the parent BlocBuilder now
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEvolutionCard(Pokemon pokemonDetails) {
    return _buildDetailCard(
      title: 'Evolusi',
      children: [
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: pokemonDetails.evolutions!.length,
            separatorBuilder: (context, index) =>
                const Icon(Icons.arrow_forward, color: Colors.grey),
            itemBuilder: (context, index) {
              final evolution = pokemonDetails.evolutions![index];
              final imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${evolution['id']}.png';
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(imageUrl, height: 80, width: 80),
                  const SizedBox(height: 4),
                  Text(evolution['name'].toString().toUpperCase()),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
