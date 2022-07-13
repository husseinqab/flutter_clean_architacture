import 'dart:convert';

import 'package:flutter_clean_arch/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main (){
  late NumberTriviaLocalDatasourceImpl datasourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasourceImpl = NumberTriviaLocalDatasourceImpl(mockSharedPreferences);
  });
  
  
  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('should return NumberTrivia from sharedPreferences when there is one in the cache', () async {
      // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
      // act
      final result = datasourceImpl.getLastNumberTrivia();
      // assert
      verify(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, equals(tNumberTriviaModel));
    });
  });
}