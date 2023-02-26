import 'package:yoyo_calculator/provider/calculator_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:yoyo_calculator/theme.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final bool isColored, isEqualSign, canBeFirst;
  const CalculatorButton(
    this.label, {
    this.isColored = false,
    this.isEqualSign = false,
    this.canBeFirst = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    final calculatorProvider =
        Provider.of<CalculatorProvider>(context, listen: false);
    return isEqualSign
        ? FilledButton(
            onPressed: () {
              calculatorProvider.addToEquation(
                label,
                canBeFirst,
                context,
              );
            },
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ))
        : Button(
            onPressed: () {
              calculatorProvider.addToEquation(
                label,
                canBeFirst,
                context,
              );
            },
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: isColored
                      ? appTheme.color
                      : (appTheme.mode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black),
                  fontSize: 20,
                ),
              ),
            ));
  }
}

List<CalculatorButton> buttons = <CalculatorButton>[
  const CalculatorButton('AC', canBeFirst: false),
  const CalculatorButton('⌫', canBeFirst: false),
  const CalculatorButton('.', canBeFirst: false),
  const CalculatorButton(' ÷ ', isColored: true, canBeFirst: false),
  const CalculatorButton('7'),
  const CalculatorButton('8'),
  const CalculatorButton('9'),
  const CalculatorButton(' × ', isColored: true, canBeFirst: false),
  const CalculatorButton('4'),
  const CalculatorButton('5'),
  const CalculatorButton('6'),
  const CalculatorButton(' - ', isColored: true, canBeFirst: false),
  const CalculatorButton('1'),
  const CalculatorButton('2'),
  const CalculatorButton('3'),
  const CalculatorButton(' + ', isColored: true, canBeFirst: false),
  const CalculatorButton('00'),
  const CalculatorButton('0'),
  const CalculatorButton('000'),
  const CalculatorButton('=', isEqualSign: true, canBeFirst: false),
];
