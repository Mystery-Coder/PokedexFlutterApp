import 'package:flutter/material.dart';
import 'package:pokedex/pokecard.dart';

class PokeList extends StatelessWidget {
  final List<PokeCard> pokemonList;

  const PokeList(
      {Key? key, required this.pokemonList}
      ) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, //No. of columns for grid
      children: pokemonList,
      crossAxisSpacing: 8,
      mainAxisSpacing: 9,
    );
  }
}
