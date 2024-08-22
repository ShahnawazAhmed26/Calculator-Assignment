import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'currency_converter.dart'; // Import the currency converter screen
import 'conversion_selector.dart'; // Import the conversions selector screen

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> with SingleTickerProviderStateMixin {
  String display = '0';
  String expression = '';
  List<String> history = [];
  bool isScientific = false; // This toggles between standard and scientific calculator
  bool showHistoryButton = true; // Controls which button to show
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "CALCULATOR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu), // Slider icon on the left
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer when pressed
              },
            );
          },
        ),
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: showHistoryButton
                ? ScaleTransition(
                    scale: _animation,
                    child: IconButton(
                      key: ValueKey('history'),
                      icon: Icon(Icons.history),
                      onPressed: () {
                        setState(() {
                          showHistoryButton = !showHistoryButton;
                          _animationController.forward().then((_) {
                            _animationController.reverse();
                          });
                        });
                        showHistory();
                      },
                    ),
                  )
                : ScaleTransition(
                    scale: _animation,
                    child: IconButton(
                      key: ValueKey('converters'),
                      icon: Icon(Icons.swap_horiz),
                      onPressed: () {
                        setState(() {
                          showHistoryButton = !showHistoryButton;
                          _animationController.forward().then((_) {
                            _animationController.reverse();
                          });
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ConversionsSelector()),
                        );
                      },
                    ),
                  ),
          ),
          IconButton(
            icon: Icon(Icons.currency_exchange), // Add the most right icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrencyConverter()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Center(
                child: Text(
                  "Calculator Modes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text(
                "Standard",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                setState(() {
                  isScientific = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Scientific",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                setState(() {
                  isScientific = true;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
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
            child: Column(
              children: [
                Expanded(
                  flex: 6, // Adjusts the height of the button grid
                  child: Column(
                    children: _buildButtonRows(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildButtonRows() {
    final buttonLabels = isScientific ? _scientificButtonLabels : _buttonLabels;
    List<Widget> rows = [];
    for (int i = 0; i < buttonLabels.length; i += 4) {
      rows.add(
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttonLabels.sublist(i, i + 4).map((button) {
              final isOperator = ['÷', '*', '-', '+', '=', '⌫'].contains(button);
              return Flexible(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    calculation(button);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOperator
                        ? Colors.yellow
                        : Colors.grey[850],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(20),
                  ),
                  child: Text(
                    button,
                    style: TextStyle(
                      fontSize: 20,
                      color: isOperator ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
    return rows;
  }

  final List<String> _buttonLabels = [
    'AC', '+/-', '%', '⌫',
    '7', '8', '9', '÷',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    '0', '.', '=', '+'
  ];

  final List<String> _scientificButtonLabels = [
    'AC', '+/-', '%', '⌫',
    '7', '8', '9', '÷',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    '0', '.', '=', '+',
    'sin', 'cos', 'tan', '√',
    'ln', 'log', 'e', 'π'
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
        if (display != '0') {
          if (display.startsWith('-')) {
            display = display.substring(1);
          } else {
            display = '-' + display;
          }
          expression = display;
        }
      } else if (buttonText == '%') {
        if (display != '0' && display.isNotEmpty) {
          double currentValue = double.tryParse(display) ?? 0;
          display = (currentValue / 100).toString();
          expression = display;
        }
      } else if (buttonText == '=') {
        try {
          final parsedExpression = Expression.parse(expression.replaceAll('÷', '/'));
          final evaluator = const ExpressionEvaluator();
          final result = evaluator.eval(parsedExpression, {});
          display = result.toString();
          history.add('$expression = $display');
          expression = display;
        } catch (e) {
          display = 'Error';
          expression = '';
        }
      } else if (buttonText == '⌫') {
        if (display.isNotEmpty) {
          display = display.substring(0, display.length - 1);
          if (display.isEmpty) display = '0';
          expression = display.replaceAll('x', '*').replaceAll('÷', '/');
        }
      } else {
        if (display == '0') {
          display = buttonText;
        } else {
          display += buttonText;
        }
        expression = display.replaceAll('x', '*').replaceAll('÷', '/');
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
