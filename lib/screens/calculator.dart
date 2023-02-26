import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_calculator/provider/calculator_provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:yoyo_calculator/widgets/history.dart';

import 'package:yoyo_calculator/widgets/page.dart';
import 'package:yoyo_calculator/widgets/calculator.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> with PageMixin {
  bool selected = true;
  String? comboboxValue;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));

    return ChangeNotifierProvider<CalculatorProvider>(
        create: (_) => CalculatorProvider(),
        child: ScreenTypeLayout.builder(
          mobile: (BuildContext context) => const MobileWidget(),
          tablet: (BuildContext context) => Expanded(
            child: Row(
              children: const [MobileWidget(), HistoryWidget()],
            ),
          ),
        ));
  }
}

class MobileWidget extends StatelessWidget {
  const MobileWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Calculator(context);
  }
}

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return History();
  }
}
