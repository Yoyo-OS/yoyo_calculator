import 'package:yoyo_calculator/provider/calculator_provider.dart';
import 'imports.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Calculator extends StatelessWidget {
  const Calculator(BuildContext context, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return SizedBox(
      width: 440,
      child: Column(
        children: [
          Container(
            width: mediaQuery.width,
            height: mediaQuery.height * .3,
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 20.0,
                  child: ListView(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Consumer<CalculatorProvider>(
                        builder: (context, equation, child) => Text(
                          equation.equation,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Consumer<CalculatorProvider>(
                  builder: (context, equation, child) => Text(
                    equation.result,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(15.0),
              crossAxisSpacing: 5.0,
              childAspectRatio: 1.3,
              mainAxisSpacing: 5.0,
              crossAxisCount: 4,
              shrinkWrap: true,
              children: buttons,
            ),
          ),
        ],
      ),
    );
  }
}
