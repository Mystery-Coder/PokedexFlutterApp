import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:pokedex/stateless/pokemoves.dart';
import 'package:pokedex/stateless/poketypes.dart';

class SpecificPokemonPage extends StatefulWidget {
  const SpecificPokemonPage({Key? key}) : super(key: key);

  @override
  State<SpecificPokemonPage> createState() => _SpecificPokemonPageState();
}

class _SpecificPokemonPageState extends State<SpecificPokemonPage>  {
  Map data = {};
  var pokemonName = '';
  bool isLoaded = false;
  var pokemonSpecs = {}; //Big image, id, description, types,etc.
  TextStyle styling = const TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w300
  );

  void getPokemonSpecs() async {
    var res1 = await get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonName'));
    var data1 = jsonDecode(res1.body);
    var id = data1["id"];
    var bigImageURL = data1["sprites"]["other"]["official-artwork"]["front_default"];
    var detailedMoves = data1["moves"];
    var moves = [];
    var types = [];

    for(int i = 0; i < data1["types"].length; i++) {
      types.add(data1["types"][i]["type"]["name"]);
    }

    if(detailedMoves.length >= 4) { //Getting 4 or less moves, cause some have 80-90 moves
      for(int i = 0;  i < 4; i++) {
        moves.add(detailedMoves[i]["move"]["name"]);
      }
    } else {
      for(int i = 0;  i < detailedMoves.length; i++) {
        moves.add(detailedMoves[i]["move"]["name"]);
      }
    }

    var res2 = await get(Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$id/')); //Has info about legendary
    var data2 = jsonDecode(res2.body);
    var isLegendary = data2["is_legendary"];
    var isMythical = data2["is_mythical"];

    if(mounted) {
      setState(() {
        pokemonSpecs["id"] = id;
        pokemonSpecs["bigImageURL"] = bigImageURL;
        pokemonSpecs["types"] = types;
        pokemonSpecs["moves"] = moves;
        pokemonSpecs["is_legendary"] = isLegendary;
        pokemonSpecs["is_mythical"] = isMythical;
        isLoaded = true;
      });
    }

  }


  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context)?.settings.arguments as Map;
    pokemonName = data["pokemonName"];

    getPokemonSpecs();
    return  Scaffold(
      appBar: AppBar(
        title: Text("Details for $capitalPokeName"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Conditional.single(
        context: context,
        conditionBuilder: (context) => isLoaded == true,
        widgetBuilder: (context) => Center(
          child: Column(
            children: [
              Image.network(pokemonSpecs["bigImageURL"]),
              Text(
                "$capitalPokeName is Pokemon no.${pokemonSpecs["id"]}",
                style: styling,
              ),
              const SizedBox( height: 20,),
              Text(
                "Types are,",
                style: styling,
              ),
              PokeTypes(types: pokemonSpecs["types"]),
              const SizedBox( height: 20,),
              Text(
                "Some moves are,",
                style: styling,
              ),
              PokeMoves(moves: pokemonSpecs["moves"]),
              const SizedBox(height: 20,),
              Text(
                "It is ${pokemonSpecs["is_legendary"] ? "a" : "not a"} legendary pokemon",
                style: styling,
              ),
              Text(
                "It is ${pokemonSpecs["is_mythical"] ? "a" : "not a"} mythical pokemon",
                style: styling,
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
        fallbackBuilder: (context) => const Center(
          child: SpinKitFadingGrid(
            color: Colors.deepPurpleAccent,
          ),
        )
      )
    );
  }

  String get capitalPokeName => pokemonName[0].toUpperCase() + pokemonName.substring(1);
}

