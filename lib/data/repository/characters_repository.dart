import 'package:breaking_bad_proj/data/models/characters.dart';
import 'package:breaking_bad_proj/data/web_secvices/characters_web_services.dart';

// repository >> doing {map}
class CharactersRepository {
  final CharactersWebServices charactersWebServices;
  CharactersRepository(this.charactersWebServices);
  // pass data from services to repository
  Future<List<CharactersModel>> getCharacters() async {
    try {
      final characters = await charactersWebServices.getCharacters();
      return characters
          .map(
            (character) =>
                CharactersModel.fromJson(character as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
