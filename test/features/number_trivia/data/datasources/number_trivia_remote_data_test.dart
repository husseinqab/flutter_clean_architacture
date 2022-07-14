import 'dart:convert';
import 'dart:math';

import 'package:flutter_clean_arch/core/error/exceptions.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200(){
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404(){
    when(mockHttpClient.get(any,headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('something went wrong',404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        'should perform a get request on the url with number'
        ' being the endpoint and with application/json header', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSourceImpl.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockHttpClient.get(Uri.parse("http://numbersapi.com/$tNumber"),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return number trivia when the response code is 200 (success)', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, tNumberTriviaModel);
    });
    
    test('should throw exception when the response code is not 200 (fail)', () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = dataSourceImpl.getConcreteNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        'should perform a get request on the url with number'
            ' being the endpoint and with application/json header', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSourceImpl.getRandomNumberTrivia();
      //assert
      verify(mockHttpClient.get(Uri.parse("http://numbersapi.com/random"),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return number trivia when the response code is 200 (success)', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSourceImpl.getRandomNumberTrivia();
      //assert
      expect(result, tNumberTriviaModel);
    });

    test('should throw exception when the response code is not 200 (fail)', () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = dataSourceImpl.getRandomNumberTrivia();
      //assert
      expect(() => call, throwsA(TypeMatcher<ServerException>()));
    });
  });
}
