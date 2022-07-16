import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_arch/core/error/failures.dart';
import 'package:flutter_clean_arch/core/usecases/usecase.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const Server_Failure_Message = 'Server Failure';
const CACHE_Failure_Message = 'Cache Failure';
const INVALID_INPUT_Failure_Message =
    'Invalid Input - the number must be positive number or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getRandomNumberTrivia,
      required this.getConcreteNumberTrivia,
      required this.inputConverter})
      : super(NumberTriviaInitial()) {
    on<NumberTriviaEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is GetTriviaForConcreteNumberEvent) {
        final inputEither =
            inputConverter.stringToUnSignedInteger(event.numberString);

       await inputEither.fold((fail) async {
          emit(
              const NumberTriviaFailed(message: INVALID_INPUT_Failure_Message));
        }, (integer) async {
          emit(NumberTriviaLoading());
          final failureOrTrivia =
              await getConcreteNumberTrivia(Params(number: integer));
          _eitherLoadedOrErrorState(failureOrTrivia, emit);
        });
      } else if (event is GetTriviaForRandomNumberEvent) {
        emit(NumberTriviaLoading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());
        _eitherLoadedOrErrorState(failureOrTrivia, emit);
      }
    });
  }

  void _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
    Emitter<NumberTriviaState> emit,
  ) {
    failureOrTrivia.fold((failure) async {
      emit(NumberTriviaFailed(message: _mapFailureToMessage(failure)));
    }, (numberTrivia) async {
      emit(NumberTriviaLoaded(numberTrivia: numberTrivia));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return Server_Failure_Message;
      case CacheFailure:
        return CACHE_Failure_Message;
      default:
        return 'Unexpected Error';
    }
  }
}
