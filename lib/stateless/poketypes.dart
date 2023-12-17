import 'package:flutter/material.dart';
//This widget takes a list of types of a pokemon and properly colourises it
const Map<String,String> coloursOfTypes = {
  "normal": '#A8A77A',
  "fire": '#EE8130',
  "water": '#6390F0',
  "electric": '#F7D02C',
  "grass": '#7AC74C',
  "ice": '#96D9D6',
  "fighting": '#C22E28',
  "poison": '#A33EA1',
  "ground": '#E2BF65',
  "flying": '#A98FF3',
  "psychic": '#F95587',
  "bug": '#A6B91A',
  "rock": '#B6A136',
  "ghost": '#735797',
  "dragon": '#6F35FC',
  "dark": '#705746',
  "steel": '#B7B7CE',
  "fairy": '#D685AD',
};

int colorConvert(String? color) {
  color = color!.replaceAll("#", "");
  if (color.length == 6) {
    return int.parse("0xFF"+color);
  } else if (color.length == 8) {
    return int.parse("0x"+color);
  } else {
    return 0xfff;
  }
}

class PokeTypes extends StatelessWidget {
  final List types;
  final double textSize;

  const PokeTypes(
      { Key? key, required this.types, this.textSize = 17 }
      ) : super(key: key);


  @override
  Widget build(BuildContext context) {
    List<InlineSpan> typesWidgets = [];

    for(int i = 0; i < types.length; i++) {
      var widget = TextSpan(
        text: types[i].toUpperCase(),
        style: TextStyle(
          backgroundColor: Color(colorConvert(coloursOfTypes[types[i]]) ),//types has type of the pokemon, get the colour with type
          color: Colors.white,
          fontSize: textSize
        )
      );
      typesWidgets.add(widget);
      typesWidgets.add(const TextSpan(text: " "));
    }

    return RichText(
      text: TextSpan(
        children: typesWidgets,
      ),
    );
  }
}

