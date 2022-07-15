import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import '../../../../injection_container.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Trivia"),
      ),
      body: _bodyBuilder(context),
    );
  }

  BlocProvider<NumberTriviaBloc> _bodyBuilder(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                const SizedBox(height: 10),
                //top half
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state is NumberTriviaInitial) {
                      return const MessageDisplay(
                        text: "Start Searching!",
                      );
                    } else if (state is NumberTriviaLoading) {
                      return const LoadingWidget();
                    } else if (state is NumberTriviaLoaded) {
                      return TriviaDisplay(numberTrivia: state.numberTrivia);
                    } else if (state is NumberTriviaFailed) {
                      return MessageDisplay(text: state.message);
                    }
                    return SizedBox();
                  },
                ),
                const SizedBox(height: 20),
                //Bottom Half
                TriviaControls()
              ],
            ),
          )),
    );
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  late String inputStr;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: 'Input a number', border: OutlineInputBorder()),
            onChanged: (value) {
              inputStr = value;
            }),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  controller.clear();
                  BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumberEvent(inputStr));
                },
                child: Text("Search"),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  controller.clear();
                  context.read<NumberTriviaBloc>().add(
                        GetTriviaForRandomNumberEvent(),
                      );
                },
                child: Text("Get Random"),
              ),
            ),
          ],
        )
      ],
    );
  }
}
