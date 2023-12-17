import 'package:flutter/material.dart';
import 'package:pokedex/pokecard.dart';
import 'package:pokedex/stateless/pokelist.dart';
import 'package:http/http.dart';
import 'package:another_flushbar/flushbar.dart';

class PokedexApp extends StatefulWidget {
  const PokedexApp({Key? key}) : super(key: key);

  @override
  State<PokedexApp> createState() => _PokedexAppState();
}

class _PokedexAppState extends State<PokedexApp> {
  List pokemonNames = [];
  Map data = {};
  final TextEditingController _textFieldController = TextEditingController();
  
  Future<bool> isValidPokemon(String pokemonName) async {
    
    var response = await get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonName'));
    if(response.body == "Not Found") {
      return false;
    } else {
      return true;
    }
    

  }
  
  @override
  Widget build(BuildContext context) {


    data = ModalRoute.of(context)?.settings.arguments as Map;
    pokemonNames = data["pokemonNames"];
    var pokeCards = <PokeCard>[];

    for(int i = 0; i < pokemonNames.length; i++) {
      pokeCards.add(
        PokeCard(
          pokemonName: pokemonNames[i],
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokedex"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: PokeList(
        pokemonList: pokeCards,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var dialog = AlertDialog(
            title: const Text("Pokemon Search"),
            content:  SingleChildScrollView(
              child: TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 3)
                  ),
                  hintText: "Enter pokemon name",
                  labelText: "Pokemon Name"
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Clear"),
                onPressed: () {
                  _textFieldController.text = '';
                },
              ),
              TextButton(
                child: const Text("Go"),
                onPressed: () async {
                  bool valid = await isValidPokemon(_textFieldController.text.toLowerCase());
                  if(valid) {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/dynamic_pokemon_page', arguments: {
                      "pokemonName" : _textFieldController.text.toLowerCase()
                    });
                    _textFieldController.text = '';
                  }
                  else {
                    await Flushbar( //Give a SnackBar alert that pokemon name is invalid
                      message:
                      'Please Enter a valid pokemon name',
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ).show(context);
                  }
                },
              ),
            ],

          );

          showDialog(
            context: context,
            builder: (context) => dialog,
            barrierDismissible: true
          );
        },
        child: const Icon(Icons.search_outlined),
        tooltip: "Search",
      ),
    );
  }
}
