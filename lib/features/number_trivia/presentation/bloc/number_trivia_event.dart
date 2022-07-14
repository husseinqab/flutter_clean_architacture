part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetTriviaForConcreteNumberEvent extends NumberTriviaEvent {
  final String numberString;

  const GetTriviaForConcreteNumberEvent(this.numberString);
  @override
  // TODO: implement props
  List<Object?> get props => [numberString];
}

class GetTriviaForRandomNumberEvent extends NumberTriviaEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
