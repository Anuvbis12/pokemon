import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/services/pokemon_service.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  final PokemonService _pokemonService = PokemonService();
  Pokemon? _pokemonDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPokemonDetails();
  }

  Future<void> _fetchPokemonDetails() async {
    try {
      final details = await _pokemonService.fetchPokemonDetails(widget.pokemon);
      if (mounted) {
        setState(() {
          _pokemonDetails = details;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon.name.toUpperCase()),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pokemonDetails == null
              ? const Center(child: Text('Gagal memuat detail Pokémon'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Hero(
                          tag: _pokemonDetails!.id,
                          child: Image.network(
                            _pokemonDetails!.imageUrl,
                            height: 250,
                            width: 250,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDetailCard(
                          title: 'Info Dasar',
                          children: [
                            _buildDetailRow('Name', _pokemonDetails!.name.toUpperCase()),
                            _buildDetailRow('Height', '${_pokemonDetails!.height! / 10} m'),
                            _buildDetailRow('Weight', '${_pokemonDetails!.weight! / 10} kg'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildDetailCard(
                          title: 'Tipe',
                          children: _pokemonDetails!.types!
                              .map((type) => _buildDetailRow('', type.toUpperCase()))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                        if (_pokemonDetails!.evolutions != null &&
                            _pokemonDetails!.evolutions!.isNotEmpty)
                          _buildEvolutionCard(),
                        const SizedBox(height: 20),
                        _buildDetailCard(
                          title: 'Statistik',
                          children: _pokemonDetails!.stats!
                              .map((stat) => _buildDetailRow(
                                  stat['name'].toString().toUpperCase(),
                                  stat['base_stat'].toString()))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                        _buildDetailCard(
                          title: 'Kemampuan',
                          children: _pokemonDetails!.abilities!
                              .map((ability) => _buildDetailRow('', ability.toUpperCase()))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildEvolutionCard() {
    return _buildDetailCard(
      title: 'Evolusi',
      children: [
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _pokemonDetails!.evolutions!.length,
            separatorBuilder: (context, index) =>
                const Icon(Icons.arrow_forward, color: Colors.grey),
            itemBuilder: (context, index) {
              final evolution = _pokemonDetails!.evolutions![index];
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
