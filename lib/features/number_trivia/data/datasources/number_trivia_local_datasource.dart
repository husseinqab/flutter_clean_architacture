import 'package:flutter_clean_arch/core/error/exceptions.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection
  /// throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getLastNumberTrivia();
  ///
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}