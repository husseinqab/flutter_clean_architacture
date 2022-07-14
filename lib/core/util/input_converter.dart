import 'package:dartz/dartz.dart';

import '../error/failures.dart';

class InputConverter {
  Either<Failure,int> stringToUnSignedInteger(String str){
    //TODO
    try {
      final number = int.parse(str);

      if (number < 0){
        throw const FormatException();
      }
      return Right(number);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure{}