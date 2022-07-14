import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';
const  Server_Failure_Message = 'Server Failure';
const  CACHE_Failure_Message = 'Cache Failure';
const  INVALID_INPUT_Failure_Message = 'Invalid Input - the number must be positive number or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getRandomNumberTrivia,
      required this.getConcreteNumberTrivia,
      required this.inputConverter})
      : super(NumberTriviaInitial()) {
    on<NumberTriviaEvent>((event, emit) {
      // TODO: implement event handler
      if (event is GetTriviaForConcreteNumberEvent) {
        final inputEither = inputConverter.stringToUnSignedInteger(event.numberString);

         inputEither.fold((fail) async {
              emit(const NumberTriviaFailed(message: INVALID_INPUT_Failure_Message));
        }, (integer) async {
             emit(NumberTriviaLoading());
             final failureOrTrivia = await getConcreteNumberTrivia(Params(number: integer));
             failureOrTrivia.fold((failure) async {
               emit(const NumberTriviaFailed(message: Server_Failure_Message));
             }, (numberTrivia) async {
                 emit(NumberTriviaLoaded(numberTrivia: numberTrivia));
             });
        });
      } else if (event is GetTriviaForRandomNumberEvent) {}
    });
  }
}
