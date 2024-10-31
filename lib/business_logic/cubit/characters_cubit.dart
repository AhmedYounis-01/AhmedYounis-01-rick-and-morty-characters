import 'package:bloc/bloc.dart';
import 'package:breaking_bad_proj/data/models/characters.dart';
import 'package:breaking_bad_proj/data/repository/characters_repository.dart';
import 'package:meta/meta.dart';

part 'characters_state.dart';

// cubit>> doing emit ,,, and emit calling class Loaded in state
class CharactersCubit extends Cubit<CharactersState> {
  List<CharactersModel> characters =[];
  final CharactersRepository charactersRepository;
  CharactersCubit(this.charactersRepository) : super(CharactersInitial());
  List<CharactersModel>? retrieveAllCharacters() {
    charactersRepository.getCharacters().then(
      (characters) {
        this.characters = characters;
        emit(CharactersLoaded(characters));
      },
    );
    return characters;
  }
}
