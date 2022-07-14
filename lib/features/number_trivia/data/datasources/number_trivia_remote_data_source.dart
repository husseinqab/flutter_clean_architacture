import 'dart:convert';
import 'dart:io';

import 'package:flutter_clean_arch/core/error/exceptions.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// calls the http://numberapi.com/{number} endpoint
  /// Throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number);

  /// calls the http://numberapi.com/random endpoint
  /// Throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number) async {
    return await getTrivia(number.toString());
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return await getTrivia('random');
  }

  Future<NumberTriviaModel> getTrivia(String arg) async {
    http.Response response = await  client.get(
        Uri.parse("http://numbersapi.com/$arg"), headers:{'Content-Type': 'application/json'});
    if (response.statusCode != 200){
      throw ServerException();
    }
    return NumberTriviaModel.fromJson(json.decode(response.body));
  }

}