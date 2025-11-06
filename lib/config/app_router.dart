import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/screens/pokemon_detail_screen.dart';
import 'package:pokemon/screens/pokemon_list_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const PokemonListScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'pokemon/:name',
            // Using pageBuilder to provide a key. This forces a rebuild when the key changes.
            pageBuilder: (BuildContext context, GoRouterState state) {
              final pokemon = state.extra as Pokemon?;
              final pokemonName = state.pathParameters['name'];

              return MaterialPage(
                // The key is crucial. When the name in the URL changes, the key changes,
                // and Flutter creates a new PokemonDetailScreen instance.
                key: ValueKey(pokemonName),
                child: PokemonDetailScreen(
                  pokemon: pokemon,
                  pokemonName: pokemonName,
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
}
