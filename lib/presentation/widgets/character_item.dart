import 'package:breaking_bad_proj/constants/my_colors.dart';
import 'package:breaking_bad_proj/constants/strings.dart';
import 'package:breaking_bad_proj/data/models/characters.dart';
import 'package:flutter/material.dart';

class CharacterItem extends StatelessWidget {
  final CharactersModel
      character;
  const CharacterItem(
      {super.key, required this.character}); 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      padding: const EdgeInsetsDirectional.all(7),
      decoration: BoxDecoration(
          color: MyColors.myWhite,
          borderRadius: BorderRadiusDirectional.circular(8)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          charactersDetailsScreen,
          arguments: character,
        ),
        child: GridTile(
          footer: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Colors.black54,
            alignment: Alignment.bottomCenter,
            child: Text(
              character.name!,
              style: const TextStyle(
                  height: 1.3,
                  fontSize: 16,
                  color: MyColors.myWhite,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          child: Hero(
            tag: character.id!,
            child: Container(
                decoration: const BoxDecoration(
                  color: MyColors.myGrey,
                ),
                child: character.image!.isNotEmpty
                    ? FadeInImage.assetNetwork(
                        placeholder: "assets/images/loader.gif",
                        image: character.image!,
                        fit: BoxFit.cover,
                      )
                    : Image.asset("assets/images/dice.png")),
          ),
        ),
      ),
    );
  }
}
