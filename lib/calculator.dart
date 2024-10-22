import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'conversion_selector.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  static const Color backgroundColor = Colors.black;
  static const Color buttonColor = Color(0xFF1E1E1E);
  static const Color operatorColor = Colors.orange;
  static const Color textColor = Colors.white;

  String display = '0';
  String expression = '';
  List<String> history = [];

  final List<String> _buttonLabels = [
    'AC', '', '%', '⌫',
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
          _buildDisplay(),
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
                color: textColor,
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
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Text(
        display,
        style: TextStyle(color: textColor, fontSize: 72),
        textAlign: TextAlign.right,
      ),
    );
  }

  Expanded _buildButtonGrid() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        itemCount: _buttonLabels.length,
        itemBuilder: (context, index) {
          final button = _buttonLabels[index];

          if (button.isEmpty) {
            return const SizedBox.shrink();
          }

          return GestureDetector(
            onTap: () => calculation(button),
            child: Container(
              decoration: BoxDecoration(
                color: button == 'AC' || ['%', '⌫'].contains(button) ? operatorColor : buttonColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  button,
                  style: TextStyle(
                    fontSize: 28,
                    color: textColor,
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
      if (display == 'Error') {
        if (buttonText == '⌫') {
          display = '0';
          expression = '';
        } else if (buttonText != 'AC') {
          display = buttonText;
          expression = buttonText;
        } else {
          display = '0';
          expression = '';
        }
        return;
      }

      switch (buttonText) {
        case 'AC':
          display = '0';
          expression = '';
          break;
        case '⌫':
          display = display.length > 1 ? display.substring(0, display.length - 1) : '0';
          expression = display;
          break;
        case '+/-':
          if (display != '0') {
            display = display.startsWith('-') ? display.substring(1) : '-' + display;
          }
          break;
        case '%':
          if (display.isNotEmpty) {
            display = (double.tryParse(display) ?? 0 / 100).toString();
          }
          break;
        case '=':
          _evaluateExpression();
          break;
        default:
          if (display == '0' && buttonText != '.') {
            display = buttonText;
          } else {
            display += buttonText;
          }
          expression += buttonText;
      }
    });
  }

  void _evaluateExpression() {
    if (expression.isNotEmpty) {
      try {
        final parsedExpression = Expression.parse(expression
            .replaceAll('×', '*')
            .replaceAll('÷', '/'));
        final evaluator = const ExpressionEvaluator();
        final result = evaluator.eval(parsedExpression, {});
        display = result.toString();
        history.add('$expression = $display');
        expression = '';
      } catch (e) {
        display = 'Error';
        expression = '';
      }
    }
  }
}
