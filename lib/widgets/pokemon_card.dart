import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';

class PokemonCard extends StatefulWidget {
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
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final transform = _isHovered ? (Matrix4.identity()..scale(1.05)) : Matrix4.identity();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: transform,
          child: Card(
            color: widget.color,
            elevation: _isHovered ? 12.0 : 8.0,
            shadowColor: Colors.black.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Hero(
                    tag: widget.pokemon.id,
                    child: Image.network(
                      widget.pokemon.imageUrl,
                      height: 100,
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
                        widget.pokemon.name.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 4.0, color: Colors.black45, offset: Offset(0, 2)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      if (widget.pokemon.types != null && widget.pokemon.types!.isNotEmpty)
                        Wrap(
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: widget.pokemon.types!.map((type) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
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
        ),
      ),
    );
  }
}
