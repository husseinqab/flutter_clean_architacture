import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';


void main(){
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('should return an integer when the string represents an unsigned integer', () async {
      //arrange
       const str = '93';
      //act
       final result = inputConverter.stringToUnSignedInteger(str);
      //assert
      expect(result, const Right(93));
    });

    test('should return failure when the string does not represent an unsigned integer', () async {
      //arrange
      const str = 'not integer';
      //act
      final result = inputConverter.stringToUnSignedInteger(str);
      //assert
      expect(result,  Left(InvalidInputFailure()));
    });

    test('should return failure when the string does not represent a negative integer', () async {
      //arrange
      const str = '-12';
      //act
      final result = inputConverter.stringToUnSignedInteger(str);
      //assert
      expect(result,  Left(InvalidInputFailure()));
    });

  });
}