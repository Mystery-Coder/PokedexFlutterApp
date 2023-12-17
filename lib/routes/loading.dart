import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void getPokeData() async {
    var pokemonNames = [];

    final prefs = await SharedPreferences.getInstance();
    var cachedPokemonNames = jsonDecode((prefs.getString("cachedPokemonNames")).toString());

    if(cachedPokemonNames == null) {
      //Only executed if the 125 pokemon data is not cached for some reason
      var noOfPokemon = 150;
      var response = await get(Uri.parse("https://pokeapi.co/api/v2/pokemon/?limit=$noOfPokemon&offset=0")); //first pokemon to initially display in a grid(PokeList)
      var data = jsonDecode(response.body);
      var pokemons = data["results"];

      for(int i = 0; i < pokemons.length; i++) {
        pokemonNames.add(pokemons[i]["name"]);
      }
      await prefs.setString("cachedPokemonNames", jsonEncode(pokemonNames)); //Storing pokemon names as json string then encoding and decoding

    } else {
      pokemonNames = cachedPokemonNames;
    }


    //After getting names of pokemon from cache or API, go to next screen
    Navigator.pushReplacementNamed(context, '/pokemon_grid', arguments: {
      "pokemonNames" : pokemonNames
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPokeData();
  }



  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SpinKitFadingCube(
        color: Colors.white,
        size: 60,
      ),
      backgroundColor: Colors.deepPurple,
    );
  }
}
