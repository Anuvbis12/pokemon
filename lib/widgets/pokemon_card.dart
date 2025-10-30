import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback onTap;
  final Color color;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        elevation: 8.0, // Increased elevation for more depth
        shadowColor: Colors.black.withOpacity(0.5), // Softer shadow color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // More rounded corners
          side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1), // Subtle border
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              bottom: 10,
              right: 10,
              child: Hero(
                tag: pokemon.id,
                child: Image.network(
                  pokemon.imageUrl,
                  height: 100, // Slightly larger image
                  width: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon.name.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0, // Larger font size
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 4.0, color: Colors.black45, offset: Offset(0, 2)), // Stronger shadow
                      ]
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (pokemon.types != null && pokemon.types!.isNotEmpty)
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: pokemon.types!.map((type) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3), // More transparent
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            type,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
