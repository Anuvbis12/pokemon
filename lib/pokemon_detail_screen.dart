import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonDetailScreen extends StatefulWidget {
  final dynamic pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  Map<String, dynamic>? _pokemonDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPokemonDetails();
  }

  Future<void> _fetchPokemonDetails() async {
    final response = await http.get(Uri.parse(widget.pokemon['url']));
    if (response.statusCode == 200) {
      setState(() {
        _pokemonDetails = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon['name']),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pokemonDetails == null
              ? const Center(child: Text('Gagal memuat detail Pokémon'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.network(
                        _pokemonDetails!['sprites']['front_default'],
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      Text('Name: ${_pokemonDetails!['name']}'),
                      Text('Height: ${_pokemonDetails!['height']}'),
                      Text('Weight: ${_pokemonDetails!['weight']}'),
                      const Text('Types:'),
                      ...(_pokemonDetails!['types'] as List<dynamic>).map((typeInfo) {
                        return Text(typeInfo['type']['name']);
                      }).toList(),
                      const Text('Stats:'),
                      ...(_pokemonDetails!['stats'] as List<dynamic>).map((statInfo) {
                        return Text('${statInfo['stat']['name']}: ${statInfo['base_stat']}');
                      }).toList(),
                      const Text('Abilities:'),
                      ...(_pokemonDetails!['abilities'] as List<dynamic>).map((abilityInfo) {
                        return Text(abilityInfo['ability']['name']);
                      }).toList(),
                    ],
                  ),
                ),
    );
  }
}
