import 'package:flutter/material.dart';
import 'package:pokedex/routes/loading.dart';
import 'routes/pokedex_app.dart';
import 'routes/dynamic_pokemon_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/' : (context) => const Loading(),
      '/pokemon_grid' : (context) => const PokedexApp(),
      '/dynamic_pokemon_page' : (context) => const SpecificPokemonPage(),
    },
  ));
}

