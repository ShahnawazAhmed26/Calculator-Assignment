import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'currency_converter.dart'; // Import the currency converter screen
import 'conversion_selector.dart'; // Import the conversions selector screen


class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String display = '0';
  String expression = '';
  
  List<String> history = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "CALCULATOR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: showHistory,
          ),
         
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConversionsSelector()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Display area
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                display,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _getFontSize(display),
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Calculator buttons
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _buttonLabels.length,
                itemBuilder: (context, index) {
                  final button = _buttonLabels[index];
                  final isOperator = ['/', '*', '-', '+', '=', '⌫'].contains(button);
                  return ElevatedButton(
                    onPressed: () {
                      calculation(button);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOperator ? Colors.yellow : Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(20),
                    ),
                    child: Text(
                      button,
                      style: TextStyle(
                        fontSize: 30,
                        color: isOperator ? Colors.black : Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<String> _buttonLabels = [
    'AC', '+/-', '%', '⌫',
    '7', '8', '9', '/',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    '0', '.', '=', '+'
  ];

  double _getFontSize(String text) {
    if (text.length > 15) return 40; // Smaller font size for longer text
    if (text.length > 10) return 50; // Medium font size
    return 60; // Larger font size for shorter text
  }

  void calculation(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        display = '0';
        expression = '';
      } else if (buttonText == '+/-') {
        if (expression.isNotEmpty) {
          if (expression[0] == '-') {
            expression = expression.substring(1);
          } else {
            expression = '-' + expression;
          }
        }
      } else if (buttonText == '%') {
        if (expression.isNotEmpty) {
          expression = (double.parse(expression) / 100).toString();
        }
      } else if (buttonText == '=') {
        try {
          final parsedExpression = Expression.parse(expression);
          final evaluator = const ExpressionEvaluator();
          final result = evaluator.eval(parsedExpression, {});
          display = result.toString();
          history.add('$expression = $display');
          expression = display;
        } catch (e) {
          display = 'Error';
          expression = '';
        }
      } else if (buttonText == '⌫') { // Backspace button
        if (display.isNotEmpty) {
          display = display.substring(0, display.length - 1);
          if (display.isEmpty) display = '0';
          expression = display.replaceAll('x', '*').replaceAll('/', '/');
        }
      } else {
        if (display == '0') {
          display = buttonText;
        } else {
          display += buttonText;
        }
        expression = display.replaceAll('x', '*').replaceAll('/', '/');
      }
    });
  }

  void showHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'History',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey[800],
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        title: Text(
                          history[index],
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        trailing: Icon(Icons.history, color: Colors.yellow),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the bottom sheet
                          setState(() {
                            final parts = history[index].split(' = ');
                            if (parts.length == 2) {
                              display = parts[1];
                              expression = parts[1].replaceAll('x', '*').replaceAll('/', '/');
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
