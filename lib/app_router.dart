import 'package:breaking_bad_proj/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_bad_proj/constants/strings.dart';
import 'package:breaking_bad_proj/data/models/characters.dart';
import 'package:breaking_bad_proj/data/repository/characters_repository.dart';
import 'package:breaking_bad_proj/data/web_secvices/characters_web_services.dart';
import 'package:breaking_bad_proj/presentation/screens/character_details_screen.dart';
import 'package:breaking_bad_proj/presentation/screens/character_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;
  AppRouter() {
    charactersRepository = CharactersRepository(CharactersWebServices());
    charactersCubit = CharactersCubit(charactersRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => charactersCubit,
            child: const CharacterScreen(),
          ),
        );
      case charactersDetailsScreen:
        final character = settings.arguments as CharactersModel;
        return MaterialPageRoute(
          builder: (_) => CharactersDetailsScreen(
            charactersModel: character,
          ),
        );
    }
    return null;
  }
}
