import 'dart:convert';

import 'package:flutter_clean_arch/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection
  /// throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getLastNumberTrivia();

  ///
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDatasourceImpl implements NumberTriviaLocalDatasource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDatasourceImpl(this.sharedPreferences);

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString('CACHED_NUMBER_TRIVIA');
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    // TODO: implement cacheNumberTrivia
    final jsonNumberTrivia = json.encode(triviaToCache.toJson());
    await sharedPreferences.setString(
      'CACHED_NUMBER_TRIVIA',
      jsonNumberTrivia,
    );
    return Future.value();
  }
}
