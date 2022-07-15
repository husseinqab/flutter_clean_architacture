import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/core/error/failures.dart';
import 'package:flutter_clean_arch/core/usecases/usecase.dart';
import 'package:flutter_clean_arch/core/util/input_converter.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initial state should be empty', () async {
    //assert
    expect(bloc.state, equals(NumberTriviaInitial()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    setUpMockInputConverterSuccess(){
      when(mockInputConverter.stringToUnSignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
    }

    test(
        'should call the input converter to validate and convert the string to an unsigned integer',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));

      /// it takes time for the stream to be done so the verify is called before
      await untilCalled(mockInputConverter.stringToUnSignedInteger(any));
      //assert
      verify(mockInputConverter.stringToUnSignedInteger(tNumberString));
    });

    test('should emit [NumberTriviaStateFailed] when the input is invalid',
        () async {
      //arrange
      when(mockInputConverter.stringToUnSignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      //assert later
      final expected = [
        // NumberTriviaInitial(),
        const NumberTriviaFailed(message: INVALID_INPUT_Failure_Message),
      ];
      expectLater(
          bloc.stream,
          emitsInOrder(expected));
      //act
      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));

    });
    
    test('should get data from the concrete usecase', () async {
      //arrange
      setUpMockInputConverterSuccess();
       when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
       bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
       await untilCalled(mockGetConcreteNumberTrivia(any));
      //assert
      verify(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    test('should emit [NumberTrivia Loading, Loaded] when data is gotten successfully', () async {
      //arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
      //assert later
        final expected = [
          //NumberTriviaInitial(),
          NumberTriviaLoading(),
          const NumberTriviaLoaded(numberTrivia: tNumberTrivia),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
      //act
      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should emit [NumberTrivia Loading, Error] when getting data fails', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async =>  Left(ServerFailure()));
      //assert later
      final expected = [
        //NumberTriviaInitial(),
        NumberTriviaLoading(),
        const NumberTriviaFailed(message: Server_Failure_Message),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      //act
      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should emit [NumberTrivia Loading, Error] with a proper message for the error'
        'when getting data fails', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async =>  Left(CacheFailure()));
      //assert later
      final expected = [
        //NumberTriviaInitial(),
        NumberTriviaLoading(),
        const NumberTriviaFailed(message: CACHE_Failure_Message),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      //act
      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the random usecase', () async {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForRandomNumberEvent());
      await untilCalled(mockGetRandomNumberTrivia(any));
      //assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [NumberTrivia Loading, Loaded] when data is gotten successfully', () async {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //assert later
      final expected = [
        //NumberTriviaInitial(),
        NumberTriviaLoading(),
        const NumberTriviaLoaded(numberTrivia: tNumberTrivia),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumberEvent());
    });

    test('should emit [NumberTrivia Loading, Error] when getting data fails', () async {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async =>  Left(ServerFailure()));
      //assert later
      final expected = [
        //NumberTriviaInitial(),
        NumberTriviaLoading(),
        const NumberTriviaFailed(message: Server_Failure_Message),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumberEvent());
    });

    test('should emit [NumberTrivia Loading, Error] with a proper message for the error'
        'when getting data fails', () async {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async =>  Left(CacheFailure()));
      //assert later
      final expected = [
        //NumberTriviaInitial(),
        NumberTriviaLoading(),
        const NumberTriviaFailed(message: CACHE_Failure_Message),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumberEvent());
    });
  });
}
