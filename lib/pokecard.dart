import 'dart:convert';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pokedex/stateless/poketypes.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokeCard extends StatefulWidget {
  final String pokemonName;

  const PokeCard({
    Key? key,
    required this.pokemonName,
}) : super(key: key);

  @override
  State<PokeCard> createState() => _PokeCardState();
}

class _PokeCardState extends State<PokeCard> with AutomaticKeepAliveClientMixin {
  var isLoaded = false;
  var pokeDetails = {};

  void getSpecificPokemon() async {

    //If not mounted don't call API
    if(mounted) {
      final prefs = await SharedPreferences.getInstance();
      var cachedPokeDetails = jsonDecode(prefs.getString("${widget.pokemonName}_cachedPokeDetails").toString());

      if(cachedPokeDetails == null) {
        String pokemonURL = "https://pokeapi.co/api/v2/pokemon/${widget.pokemonName}";
        var response = await get(Uri.parse(pokemonURL));
        var data = jsonDecode(response.body);

        var types = [];
        for(int i = 0; i < data["types"].length; i++) {
          types.add(data["types"][i]["type"]["name"]);
        }
        setState(() {
          pokeDetails["name"] = data["name"][0].toUpperCase() + data["name"].substring(1,data["name"].length);
          pokeDetails["id"] = data["id"];
          pokeDetails["imageURL"] = data["sprites"]["front_default"];
          pokeDetails["types"] = types;

          isLoaded = true;
        });
        await prefs.setString("${widget.pokemonName}_cachedPokeDetails", jsonEncode(pokeDetails)); //IMPORTANT: caching the specific pokemon details

      } else {
        setState(() {
          pokeDetails = cachedPokeDetails;
          isLoaded = true;

        });
      }


    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    getSpecificPokemon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Conditional.single(
      context: context,
      conditionBuilder: (context) => isLoaded == true,
      widgetBuilder: (context) => GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/dynamic_pokemon_page', arguments: {
            "pokemonName" : widget.pokemonName
          });
        },
        child: Container( //Actual Pokemon data if loaded
          child: Column(
            children: [
              Image.network(pokeDetails["imageURL"]),
              Text(pokeDetails["name"]),
              Text("#${pokeDetails["id"]}"),
              PokeTypes(types: pokeDetails["types"])
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          height: 230,
          width: 120,
          margin: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.redAccent,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10)
          ),
        ),
      ),
      fallbackBuilder: (context) => Container( //spinning wheel if not loaded
        height: 200,
        width: 150,
        child: const Center(
          child: SpinKitFadingCircle(
            color: Colors.black,
            size: 40.0,
          ),
        ),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10)
        ),
        margin: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
      )
    ) ;
  }
}