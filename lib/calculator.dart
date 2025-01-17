import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'conversion_selector.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  static const Color backgroundColor = Colors.black87;
  static const Color buttonColor = Color(0xFF424242);
  static const Color operatorColor = Color(0xFFFFC107);
  static const Color actionColor = Color(0xFFFFC107);
  static const Color textColor = Colors.white;

  String display = 'Welcome!';
  String expression = '';
  String evaluatedResult = '';
  bool isInitialScreen = true;

  final List<String> _buttonLabels = [
    'AC', '+/-', '%', '⌫',
    '7', '8', '9', '÷',
    '4', '5', '6', '×',
    '1', '2', '3', '-',
    '0', '.', '=', '+'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildDisplay(),
          ),
          const SizedBox(height: 10),
          _buildButtonGrid(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {},
            child: Text(
              'Calculator',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ConversionsSelector()),
              );
            },
            child: Text(
              'Converter',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildDisplay() {
    evaluatedResult = _evaluateExpression(expression);

    return Container(
      alignment: isInitialScreen ? Alignment.center : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isInitialScreen ? MainAxisAlignment.center : MainAxisAlignment.end,
        children: [
          Text(
            display,
            style: TextStyle(
              color: textColor,
              fontSize: isInitialScreen ? 60 : 50,
            ),
            textAlign: isInitialScreen ? TextAlign.center : TextAlign.right,
          ),
          if (!isInitialScreen && evaluatedResult.isNotEmpty)
            Text(
              evaluatedResult,
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 36,
              ),
              textAlign: TextAlign.right,
            ),
        ],
      ),
    );
  }

  Widget _buildButtonGrid() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.1,
        ),
        itemCount: _buttonLabels.length,
        itemBuilder: (context, index) {
          final button = _buttonLabels[index];
          final isOperator = ['+', '-', '×', '÷', '=', '%', '+/-'].contains(button);
          final isAction = ['AC', '⌫'].contains(button);

          return GestureDetector(
            onTap: () => calculation(button),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                color: isOperator ? operatorColor : (isAction ? actionColor : buttonColor),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  button,
                  style: TextStyle(
                    fontSize: 28,
                    color: textColor,
                    fontWeight: isOperator || isAction
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void calculation(String buttonText) {
    setState(() {
      if (display == 'Welcome!') {
        display = '';
        isInitialScreen = false;
      }

      switch (buttonText) {
        case 'AC':
          display = '0';
          expression = '';
          isInitialScreen = true;
          break;
        case '⌫':
          display = display.length > 1
              ? display.substring(0, display.length - 1)
              : '0';
          expression = display;
          break;
        case '+/-':
          if (display != '0') {
            display = display.startsWith('-')
                ? display.substring(1)
                : '-' + display;
          }
          break;
        case '%':
          if (display.isNotEmpty) {
            display = (double.tryParse(display) ?? 0 / 100).toString();
          }
          break;
        case '=':
          _evaluateExpression(expression);
          break;
        default:
          if (display == '0' && buttonText != '.') {
            display = buttonText;
          } else {
            display += buttonText;
          }
          expression += buttonText;
          break;
      }
    });
  }

  String _evaluateExpression(String exp) {
    if (exp.isEmpty) return '';
    
    try {
      final parsedExpression = Expression.parse(
        exp.replaceAll('×', '*').replaceAll('÷', '/')
      );
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(parsedExpression, {});
      return result.toString();
    } catch (e) {
      return '';
    }
  }
}
