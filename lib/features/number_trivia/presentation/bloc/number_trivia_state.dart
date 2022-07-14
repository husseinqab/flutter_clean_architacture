part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class NumberTriviaInitial extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class NumberTriviaLoading extends NumberTriviaState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NumberTriviaLoaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  const NumberTriviaLoaded({required this.numberTrivia});

  @override
  // TODO: implement props
  List<Object?> get props => [numberTrivia];

}

class NumberTriviaFailed extends NumberTriviaState {
  final String message;

  const NumberTriviaFailed({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];

}