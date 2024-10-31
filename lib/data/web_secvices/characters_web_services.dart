import 'package:breaking_bad_proj/constants/strings.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class CharactersWebServices {
  late Dio dio;
  CharactersWebServices() {
    BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 7),
        receiveTimeout: const Duration(seconds: 7));
    dio = Dio(options);
  }
  Future<List<dynamic>> getCharacters() async {
    try {
      Response response = await dio.get('character');
      Logger().f(response.data['results']);
      // print(response.data['results']);
      return response.data['results'];
    } catch (e) {
      Logger().f(e.toString());
      //print(e.toString());
      rethrow;
    }
  }
}
