import 'package:flutter/material.dart';
//This widget takes a list of moves of a pokemon and properly lists it



class PokeMoves extends StatelessWidget {
  final List moves;

  const PokeMoves(
      { Key? key, required this.moves }
      ) : super(key: key);

  String capitalizeFirstLetter(var word) {
    return word[0].toUpperCase() + word.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    var movesInText = <Widget>[];

    for(int i = 0; i < moves.length; i++) {

      movesInText.add(Flexible(
        child: Text(
          capitalizeFirstLetter(moves[i]) + '  ',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 17.5,
          ),
        ),
      ));
    }

    return Container(
      child: Row(
        children: movesInText,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.lightBlue,
          width: 2
        )
      ),
    );
  }
}
